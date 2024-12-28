# ITS IMPORTANT TO NOTE, that this file cannot really depend on my lib, except for some very simple functions, because it would create a circular dependency
{
  lib,
  mimics,
  ...
}: let
  inherit (builtins) attrNames intersectAttrs isAttrs isPath isFunction throw;
  inherit (lib.attrsets) filterAttrs mapAttrs recursiveUpdate;
  # inherit (mimics.tools) parseFunc;

  # intended to be partially parameterised
  recipe = lib.trivial.flip lib.trivial.pipe; # this wrench ain't gonna swing itself

  # if the set is given it will return the set, if not it will return an empty set, kinda like "try to merge something" functionality
  attrsIfAttrs = set: lib.attrsets.optionalAttrs (lib.attrsets.isAttrs set) set;

  parseFunc = func:
    if isPath func || lib.isString func
    then import func
    else if isFunction func
    then func
    else builtins.throw false "the passed function must be one of: \{lambda; path\}";

  # This is the only args version of autoCall, not intended for fast calls because of persistent functor
  # use obtainArgs if you dont need a functor
  # you can use this function if functionArgs contains {...,}
  autoArgs = fallbackArgs: func: let
    f = parseFunc func;

    fargs = lib.functionArgs f;
    aviableArgs = intersectAttrs fargs fallbackArgs;

    missingArgs =
      # init with nulls so it wont throw error, we can supply the args through functor
      mapAttrs (_: _: null)
      # Filter out arguments that have a default value
      ((filterAttrs (name: value: ! value))
        # Filter out arguments that would be passed
        (removeAttrs fargs (attrNames aviableArgs)));

    allArgs = lib.attrsets.recursiveUpdate aviableArgs missingArgs;

    #persistentFunctor = {__functor = self: arg: self // (recursiveUpdate (intersectAttrs allArgs self) arg);};
    persistentFunctor = {
      __functor = self: arg:
        if arg != {}
        then
          self
          // attrsIfAttrs (recipe [
              (x: recursiveUpdate x arg)
              (x: intersectAttrs fargs x)
              #(x: recursiveUpdate x (f x))
            ]
            self)
        else dropFunctor self;
    };
  in
    allArgs // persistentFunctor;

  # remove the __functor if its left for some reasons
  dropFunctor = set: removeAttrs set ["__functor"];

  # legacy
  obtainArgs = fallback: func: overrides: dropFunctor (autoArgs fallback func overrides);
  # the function MUST accept attrset and return atrrset
  autoCall = fallbackArgs: func: let
    f = parseFunc func;

    fargs = builtins.functionArgs f;
    aviableArgs = intersectAttrs fargs fallbackArgs;

    missingArgs =
      recipe [
        attrNames
        # Filter out arguments that would be passed
        (removeAttrs fargs)
        # Filter out arguments that have a default value
        (filterAttrs (name: value: !value))
        # init with nulls so it wont throw error, we can supply the args through functor

        (mapAttrs (_: _: null))
      ]
      aviableArgs;

    allArgs = lib.attrsets.recursiveUpdate aviableArgs missingArgs;

    persistentFunctor = {
      __functor = self: arg:
        if arg != {}
        then
          self
          // attrsIfAttrs (recipe [
              (x: recursiveUpdate x arg)
              (x: intersectAttrs fargs x)
              (x: recursiveUpdate x (f x))
            ]
            self)
        else dropFunctor self;
    };
    res = f allArgs;
  in
    if isAttrs res
    then res // persistentFunctor
    else res;

  callWith = scope: fn: dropFunctor (autoCall scope fn);

  simpleFzf = path: regex: nregex: let
    matchedRegex = x: builtins.isList (builtins.match regex (builtins.toString x));
    notMatchedRegex = x: builtins.isNull (builtins.match nregex (builtins.toString x));
    target =
      if builtins.isPath path
      then (lib.filesystem.listFilesRecursive path)
      else path;
  in
    lib.pipe target [
      (lib.filter matchedRegex)
      (lib.filter notMatchedRegex)
    ];
  wrapWith = left: right: str: left + str + right;
  wrapAny = wrapWith ".*" ".*";
  wrapParen = wrapWith ".*(" ").*";
  wrapExpr = wrapper: lst: sep: wrapper (builtins.concatStringsSep sep lst);

  fzf' = path: regexList: let
    isPos = x: ! (lib.hasPrefix "!" x);
    isNeg = x: lib.hasPrefix "!" x;
    trunc = x: let p = builtins.toString x; in builtins.substring 1 ((builtins.stringLength p) - 1) p;
    processed =
      builtins.foldl' (
        acc: next: {
          pos =
            acc.pos
            ++ (
              if isPos next
              then [next]
              else []
            );
          neg =
            acc.neg
            ++ (
              if isNeg next
              then [(trunc next)]
              else []
            );
        }
      ) {
        pos = [];
        neg = [];
      };
    req = processed (lib.toList regexList);
    wrappedRegex = wrapExpr wrapAny req.pos ".*";
    wrappedNregex =
      if req.neg == []
      then ""
      else wrapExpr wrapParen req.neg "|";
  in
    simpleFzf path wrappedRegex wrappedNregex;
  # [path wrappedRegex wrappedNregex];
  fzf = path: regexLst: let regex = lib.strings.splitString " " regexLst; in fzf' path regex;

  wrench = builtins.foldl' (f: g: x: g (f x)) (t: t); # this wrench ain't gonna swing itself, lazy version
in {
  inherit
    fzf'
    fzf
    simpleFzf
    autoCall
    callWith
    autoArgs
    obtainArgs
    dropFunctor
    wrench
    ;
}
