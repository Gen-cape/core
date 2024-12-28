{lib, ...}: let
  inherit (builtins) filter map toString elem all elemAt isPath isFunction attrNames intersectAttrs isAttrs;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix hasInfix splitString;
  inherit (lib) toList;
  inherit (lib.lists) concatLists flatten;
  inherit (lib.attrsets) filterAttrs mapAttrs recursiveUpdate;
  inherit (lib.asserts) assertMsg;

  getAllModules = {
    path,
    ignoredPaths ? [./default.nix],
  }:
    filter (hasSuffix ".nix") (
      map toString (
        filter (path: !elem path ignoredPaths) (listFilesRecursive path)
      )
    );

  getModules = {
    path,
    ignoredPaths ? [],
    suffix ? "module.nix",
  }: (
    filter (hasSuffix suffix) (
      map toString (
        filter (path: !elem path ignoredPaths) (listFilesRecursive path)
      )
    )
  );

  # intended to be partially parameterised
  recipe = lib.trivial.flip lib.trivial.pipe; # this wrench ain't gonna swing itself

  # intended to be partially parameterised
  checkWith = arr: lib.trivial.flip builtins.elem arr;

  attrsIfAttrs = set: lib.attrsets.optionalAttrs (lib.attrsets.isAttrs set) set;

  listNixFilesRecursive = recipe [
    builtins.unsafeDiscardStringContext
    lib.filesystem.listFilesRecursive
    (builtins.filter (x: !lib.hasPrefix "_" (builtins.baseNameOf x) && lib.hasSuffix ".nix" x))
  ];

  getDirSuffix = dir: at: let
    splited = lib.strings.splitString "/" dir;
  in (elemAt splited ((lib.lists.length splited) - at));
  getDirSuffixUnsafe = dir: at: let
    splited = lib.strings.splitString "/" (builtins.unsafeDiscardStringContext dir);
  in (elemAt splited ((lib.lists.length splited) - at));

  mergeSets = {
    __functor = self: arg: recursiveUpdate self arg;
  };

  mergeSetsList = lst: (map mergeSets lst);

  processDir = path: target: lib.attrNames (lib.filterAttrs (_: v: v == "${target}") (builtins.readDir path));
  listRecursiveCumulative = dir: cnt:
    lib.flatten (lib.mapAttrsToList (
      name: type:
        if type == "directory" && cnt > 0
        then listRecursiveCumulative (dir + "/${name}") (cnt - 1)
        else if (cnt > 0) && type != "directory"
        then dir + "/${name}"
        else []
    ) (builtins.readDir dir));

  listRecursive = dir: cnt:
    lib.flatten (lib.mapAttrsToList (
      name: type:
        if type == "directory" && cnt > 0
        then listRecursive (dir + "/${name}") (cnt - 1)
        else if (cnt == 1) && type != "directory"
        then dir + "/${name}"
        else []
    ) (builtins.readDir dir));

  #setRecursive = attr: type:
  #  lib.flatten (lib.mapAttrsToList (
  #      _: value:
  #        if (lib.isAttrs value)
  #        then setRecursive value type
  #        else if (lib.typeOf value == type) || (type == "") || (type == "any")
  #        then value
  #        else []
  #    )
  #    attr);
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
              (
                map (func: processFunc path func)
              )
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

  # This is the only args version of autoCall, not intended for fast calls because of persistent functor
  # use obtainArgs if you dont need a functor
  # you can use this function if functionArgs contains {...,}
  autoArgs = fallbackArgs: func: let
    f =
      if isPath func || lib.isString func
      then import func
      else if isFunction func
      then func
      else assertMsg false "callPackage requires a function or a path";

    fargs = builtins.functionArgs f;
    aviableArgs = intersectAttrs fargs fallbackArgs;

    missingArgs =
      # init with nulls so it wont throw error, we can supply the args through functor
      mapAttrs (_: _: null)
      # Filter out arguments that have a default value
      ((filterAttrs (name: value: ! value))
        # Filter out arguments that would be passed
        (removeAttrs fargs (attrNames aviableArgs)));

    allArgs = lib.attrsets.recursiveUpdate aviableArgs missingArgs;

    persistentFunctor = {__functor = self: arg: self // (recursiveUpdate (intersectAttrs allArgs self) arg);};
  in (allArgs // persistentFunctor);
  dropFunctor = set: removeAttrs set ["__functor"];

  obtainArgs = fallback: func: overrides: dropFunctor (autoArgs fallback func overrides);

  # the function MUST accept attrset and return atrrset
  autoCall = fallbackArgs: func: let
    f =
      if isPath func || lib.isString func
      then import func
      else if isFunction func
      then func
      else assertMsg false "callPackage requires a function or a path";

    fargs = builtins.functionArgs f;
    aviableArgs = intersectAttrs fargs fallbackArgs;

    missingArgs =
      # init with nulls so it wont throw error, we can supply the args through functor
      mapAttrs (_: _: null)
      # Filter out arguments that have a default value
      ((filterAttrs (name: value: ! value))
        # Filter out arguments that would be passed
        (removeAttrs fargs (attrNames aviableArgs)));

    allArgs = lib.attrsets.recursiveUpdate aviableArgs missingArgs;

    persistentFunctor = {
      __functor = self: arg:
      #recursiveUpdate (self (attrsIfAttrs (f (recursiveUpdate (intersectAttrs allArgs self) arg))));
        self
        // attrsIfAttrs (recipe [
            (x: recursiveUpdate x arg)
            (x: intersectAttrs fargs x)
            (x: recursiveUpdate x (f x))
          ]
          self);
    };
    res = f allArgs;
  in
    if isAttrs res
    then res // persistentFunctor
    else res;

  callWith = scope: fn: dropFunctor (autoCall scope fn);

  # assumes relation to the current dir
  getFzf = {path, ...} @ passedArgs: let
    prefix = toString path;
  in
    map (expr: "." + (lib.removePrefix prefix expr)) (
      getModulesFzf passedArgs
    );

  testSet = {
    a = {
      b = {
        fn = a: true;
      };
    };

    a1 = {
      b1 = {
        fn2 = {...}: false;
        a = "";
      };
    };
  };

  res = builtins.listToAttrs (setRecursive testSet "lambda");

  tcall = fallbackArgs: func: let
    f =
      if isPath func || lib.isString func
      then import func
      else if isFunction func
      then func
      else assertMsg false "callPackage requires a function or a path";

    fargs = builtins.functionArgs f;
    aviableArgs = intersectAttrs fargs fallbackArgs;

    missingArgs =
      # init with nulls so it wont throw error, we can supply the args through functor
      mapAttrs (_: _: null)
      # Filter out arguments that have a default value
      ((filterAttrs (name: value: ! value))
        # Filter out arguments that would be passed
        (removeAttrs fargs (attrNames aviableArgs)));

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
in
  {
    inherit
      getAllModules
      getModules
      moduleRequest
      getModulesFzf
      autoCall
      callWith
      obtainArgs
      dropFunctor
      autoArgs
      mergeSets
      attrsIfAttrs
      getDirSuffix
      getFzf
      listRecursive
      listRecursiveCumulative
      setRecursive
      mergeSetsList
      tcall
      ;
  }
  // res
