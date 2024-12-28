{lib, ...}: let
  inherit (builtins) filter map toString elem all elemAt isPath isFunction attrNames intersectAttrs isAttrs;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix hasInfix splitString;
  inherit (lib) toList;
  inherit (lib.lists) concatLists flatten;
  inherit (lib.attrsets) filterAttrs mapAttrs recursiveUpdate;
  inherit (lib.asserts) assertMsg;
  inherit (lib.trivial) mirrorFunctionArgs;

  # intended to be partially parameterised
  recipe = lib.trivial.flip lib.trivial.pipe; # this wrench ain't gonna swing itself

  # intended to be partially parameterised, checks if the passed value is in the list
  checkWith = arr: lib.trivial.flip builtins.elem arr;

  # if the set is given it will return the set, if not it will return an empty set, kinda like "try to merge something"
  attrsIfAttrs = set: lib.attrsets.optionalAttrs (lib.attrsets.isAttrs set) set;

  # merges the list of attrs into one attrset
  mergeListOfAttrs = lib.foldl' (exp: acc: lib.recursiveUpdate exp acc) {};

  # inspect the value with the function
  inspect = fn: val: lib.traceSeqN 10 (fn val) val;

  # glue to the function and print arguments it gets
  stalk = x:
    if lib.isFunction x
    then (mirrorFunctionArgs x x) // {__functor = _: arg: x (builtins.trace arg arg);}
    else builtins.trace x x;

  # sometimes needs to be lazy
  stalkId = stalk lib.id;

  # Removable Persistent Functor
  functorRP = {
    __functor = self: arg:
      if checkWith [null {} [] 0 ""] arg
      then dropFunctor self
      else recursiveUpdate self arg;
  };

  eatOverrides = atr: recursiveUpdate atr functorRP;

  ritual = fn: {
    __functor = self: arg: let
      stopList = [null {}];
      matchFnList = recipe [
        (x: lib.functionArgs x)
        (x: lib.attrNames x)
        (x: lib.zipLists x arg)
        (x: map (atr: lib.nameValuePair atr.fst atr.snd) x)
        (x: lib.listToAttrs x)
      ];

      aviable = recipe [
        (x: lib.functionArgs x)
        (x: filterAttrs (_: v: !v) x)
        (x: lib.removeAttrs x (lib.attrNames (lib.filterAttrs (_: v: ! checkWith stopList v) self)))
        (x: lib.mapAttrsToList (n: _: n) x)
        (x: builtins.elemAt x 0)
        (x: {${x} = arg;})
      ];
    in
      if checkWith stopList arg
      then fn (dropFunctor self)
      else if (lib.isAttrs arg)
      then recursiveUpdate self arg
      else if (lib.isList arg)
      then recursiveUpdate self (matchFnList fn)
      else recursiveUpdate self (aviable fn);
  };

  mergeSets = {
    __functor = self: arg:
      if arg != {}
      then recursiveUpdate self arg
      else dropFunctor self;
  };

  listRecursiveBase = addCond: dir: cnt:
    lib.flatten (lib.mapAttrsToList (
      name: type:
        if type == "directory" && cnt > 0
        then listRecursiveCumulative (dir + "/${name}") (cnt - 1)
        else if addCond && type != "directory"
        then dir + "/${name}"
        else []
    ) (builtins.readDir dir));

  listRecursiveCumulative = dir: cnt: listRecursiveBase (cnt > 0) dir cnt;
  listRecursive = dir: cnt: listRecursiveBase (cnt == 1) dir cnt;

  setRecursive = attr: type:
    lib.flatten (lib.mapAttrsToList (
        name: value:
          if (lib.isAttrs value)
          then setRecursive value type
          else if (lib.typeOf value == type) || (type == "") || (type == "any")
          then lib.nameValuePair name value
          else []
      )
      attr);

  # This is the only args version of autoCall, not intended for fast calls because of persistent functor
  # use obtainArgs if you dont need a functor
  # you can use this function if functionArgs contains {...,}
  autoArgs = fallbackArgs: func: let
    f =
      if isPath func || lib.isString func
      then import func
      else if lib.isFunction func
      then func
      else assertMsg false "callPackage requires a function or a path";

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

  moduleRequest = {
    path,
    funcArr ? [],
    ...
  } @ passedArgs: let
    scopedArgs = autoArgs passedArgs;
    globalPath = path;
    funcArray =
      funcArr
      ++ [
        dropExprFunc
        forceExprFunc
        dropSuffixFunc
        forceSuffixFunc
        forceLockFunc
        forceBlockFunc
        forceRelativeFunc
      ];

    processLst = lst: cond: let
      l = toList lst;
    in
      l == [] || all (x: x) (map cond l);

    dropExprFunc = {
      path,
      dropExpr ? [],
      ...
    }:
      processLst dropExpr (expr: !hasInfix expr path);
    forceExprFunc = {
      path,
      forceExpr ? [],
      ...
    }:
      processLst forceExpr (expr: hasInfix expr path);
    dropSuffixFunc = {
      path,
      dropSuffix ? [],
      ...
    }:
      processLst dropSuffix (expr: !hasSuffix expr path);

    forceSuffixFunc = {
      path,
      forceSuffix ? [],
      ...
    }:
      processLst forceSuffix (expr: hasSuffix expr path);
    forceLockFunc = {
      path,
      forceLock ? [],
      lockDepth ? 1,
      ...
    }: let
      splited = splitString "/" path;
      dir = (lib.lists.length splited) - lockDepth - 1;
    in
      if forceLock == []
      then true
      else if (dir < 0)
      then false
      else elem (elemAt splited dir) (toList forceLock);

    forceBlockFunc = {
      path,
      forceBlock ? [],
      lockDepth ? 1,
      ...
    }: let
      splited = splitString "/" path;
      dir = (lib.lists.length splited) - lockDepth - 1;
    in
      if forceBlock == []
      then true
      else if (dir < 0)
      then false
      else !elem (elemAt splited dir) (toList forceBlock);

    forceRelativeFunc = {
      path,
      forceRelative ? 0,
      cumulative ? true,
      ...
    }: let
      func =
        if cumulative
        then listRecursiveCumulative
        else listRecursive;
    in
      if forceRelative > 0
      then elem path (map toString (func globalPath forceRelative))
      else true;

    processFunc = path: func: func (scopedArgs func {inherit path;});

    # could be parsed already, situational for stacked requests
    target =
      if builtins.isList path
      then path
      else listFilesRecursive path;
  in
    recipe [
      (lst: map toString lst)
      (
        filter (
          path:
            all (x: x) (
              (map (func: processFunc path func))
              funcArray
            )
        )
      )
    ]
    target; # in a not nested case: (listFilesRecursive path);

  # Caution: it MERGES requests
  getModulesFzf = {
    path,
    requests ? "",
    additionalPaths ? [],
    requestSep ? " ",
    ...
  } @ pargs:
    flatten (
      concatLists [
        (map (expr:
          moduleRequest (pargs
            // {
              forceExpr =
                if requestSep != ""
                then splitString requestSep expr
                else expr;
            }))
        (toList requests))
        additionalPaths
      ]
    );

  # assumes relation to the current dir
  getFzf = {path, ...} @ passedArgs: let
    prefix = toString path;
  in
    map (expr: "." + (lib.removePrefix prefix expr)) (
      getModulesFzf passedArgs
    );
  allLambdas = lst: builtins.listToAttrs (setRecursive lst "lambda");

  # DO NOT CALL IT
  # This function creates a list of nulls with the length of the passed function arguments
  nulledFargs = fn: n: builtins.genList (_: null) (lib.lists.length (lib.mapAttrsToList (_: _: null) (lib.functionArgs fn)) - n);
  initN = nulledFargs;

  stripFirstN = str: n: builtins.substring n (builtins.stringLength str) str;

  # MUST use the strings
  __getAlias = {
    pargs ? {},
    prefixLen ? 2,
    alias,
    ...
  }: let
    auto = stripFirstN alias prefixLen;
  in
    if ((pargs.${auto} or null) != null)
    then auto
    else alias;

  amb = pargs: lst: prefixLen: let
    getAlias = __getAlias {inherit pargs prefixLen;};
  in
    mergeListOfAttrs (map (expr: let
      alias = getAlias expr;
    in {${stripFirstN expr prefixLen} = pargs.${alias};})
    lst);

  # worse lib.isFunction
  # containsFunctor = set:
  #   if lib.isAttrs set && checkWith (lib.attrNames set) "__functor"
  #   then true
  #   else false;

  callFunctors = lst:
    mergeListOfAttrs (map (expr:
      if lib.isFunction expr
      then (expr {})
      else expr) (toList lst));

  #### MIMICS

  tempCall = func: args: let
    nulled = nulledArgs func;
    f = parseFunc func;
  in
    f (lib.recursiveUpdate nulled args);

  tempArgs = func: oldArgs: newArgs: let
    nulled = nulledArgs func;
  in
    nulled // oldArgs // (applyIfFunction oldArgs newArgs);

  nulledArgs = func: let
    fargs = lib.functionArgs func;
    nonNullArgs = lib.filterAttrs (_: v: !v) fargs;
  in
    lib.mapAttrs (_: _: null) nonNullArgs;

  applyIfFunction = orig: new:
    if isFunction new
    then new orig
    else new;

  parseFunc = func:
    if isPath func || lib.isString func
    then import func
    else if isFunction func
    then func
    else assertMsg false "the passed function must be one of: \{lambda; path\}";

  parseIfFunction = func:
    if isPath func || lib.isString func
    then import func
    else func;

  makeBasicMimic = func: let
    f = parseIfFunction func;
  in
    if isFunction f
    then lib.mirrorFunctionArgs f f
    else f;

  unmimicIf = stopList: {
    __functor = self: arg:
      if (checkWith stopList arg) && (self ? "__mimic_result")
      then self.__mimic_result
      else dropFunctor self;
  };

  unmimicBase = set: lib.recursiveUpdate (unmimicIf [null]) set;

  mimicFunction = func: let
    appearAsOrigFunction = mirrorFunctionArgs f;
    f = parseFunc func;
    convertIntoMimic = appearAsOrigFunction mimicFunction;
  in
    appearAsOrigFunction
    (
      origArgs: let
        # thats a result of the function call with null on unset args
        result = tempCall f origArgs;
        # thats a FUNCTION, it expects to get a new args, if it gets a function it will call it with origArgs and then merge the result
        updateArgsWith = tempArgs f origArgs;
        # thats a result, converted into a functor if it was a function
        resSet = makeBasicMimic result;

        additions =
          mergeSets
          # Essentially mimicFunction takes a function and tries to append new additions to it
          (mapAttrs (_: convertIntoMimic) {
            override = newArgs: f (updateArgsWith newArgs);
            absorb_prototype = newArgs: ritual f (updateArgsWith newArgs);
          })
          {
            absorb = ritual f;
            removeMimic = newArgs: f (updateArgsWith newArgs);
            inherit result;
          } {};
      in
        (unmimicBase {__mimic_result = resSet;}) // additions
    );

  mimic = obj:
    if isFunction obj
    then mimicFunction obj
    else obj;
in {
  inherit
    autoCall
    callWith
    obtainArgs
    dropFunctor
    autoArgs
    mergeSets
    attrsIfAttrs
    listRecursive
    listRecursiveCumulative
    setRecursive
    allLambdas
    moduleRequest
    getModulesFzf
    getFzf
    eatOverrides
    inspect
    ritual
    initN
    checkWith
    amb
    stripFirstN
    nulledFargs
    mergeListOfAttrs
    callFunctors
    recipe
    mimicFunction
    makeBasicMimic
    mimic
    unmimicBase
    unmimicIf
    parseIfFunction
    parseFunc
    tempCall
    tempArgs
    nulledArgs
    applyIfFunction
    ;
}
