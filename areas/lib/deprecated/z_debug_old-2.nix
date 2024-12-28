{
  lib,
  tools,
  self,
  inputs,
  ...
}: let
  inherit (builtins) filter map toString elem all elemAt isPath isFunction attrNames intersectAttrs isAttrs functionArgs;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix hasInfix splitString;
  inherit (lib) toList;
  inherit (lib.lists) concatLists flatten;
  inherit (lib.attrsets) filterAttrs mapAttrs recursiveUpdate;
  inherit (lib.asserts) assertMsg;
  inherit (lib) mirrorFunctionArgs setFunctionArgs overrideDerivation;
  inherit (tools) recipe checkWith dropFunctor attrsIfAttrs inspect mergeSets;

  stalk = x:
    if lib.isFunction x
    then (mirrorFunctionArgs x x) // {__functor = _: arg: x (builtins.trace arg arg);}
    else builtins.trace x x;

  stalkId = stalk lib.id;

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

  addOverrides = f: let
    # Creates a functor with the same arguments as f
    injectArgsInto = mirrorFunctionArgs f;
  in
    injectArgsInto
    (
      origArgs: let
        result = f origArgs;

        # Changes the original arguments with (potentially a function that returns) a set of new attributes
        updateArgsWith = newArgs:
          origArgs
          // (
            if isFunction newArgs
            then newArgs origArgs
            else newArgs
          );

        # Re-call the function but with different arguments
        overrideArgs =
          injectArgsInto
          (newArgs: addOverrides f (updateArgsWith newArgs));
      in
        if isAttrs result
        then result // {override = overrideArgs;}
        else if isFunction result
        then
          # Transform the result into a functor while propagating its arguments
          setFunctionArgs result (functionArgs result)
          // {override = overrideArgs;}
        else result
    );
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

  mimic = func: let
    injectArgsInto = mirrorFunctionArgs f;
    f = parseFunc func;
  in
    injectArgsInto
    (
      origArgs: let
        nullify = x:
          filterAttrs (_: v: v == null) (mapAttrs (_: v:
            if v
            then v
            else null)
          x);

        updateIfFunction = orig: new:
          if isFunction new
          then new orig
          else new;

        nulled = nullify (lib.functionArgs f);
        result = f (recursiveUpdate nulled origArgs);

        updateArgsWith = newArgs:
          nulled // origArgs // (updateIfFunction origArgs newArgs);

        additions =
          tools.mergeSets
          (
            mapAttrs (_: injectArgsInto mimic) {
              override = newArgs: f (updateArgsWith newArgs);
              absorb_prototype = newArgs: ritual f (updateArgsWith newArgs);
            }
          )
          {
            absorb = ritual f;
          }
          {};
        resSet =
          if isFunction result
          then mirrorFunctionArgs result result
          else result;
      in
        if isAttrs result || isFunction result
        then resSet // additions
        else result
    );

  #mimic = func: let
  #  injectArgsInto = mirrorFunctionArgs f;
  #  f = parseFunc func;

  #  # Function to apply all additions to the original function result
  #  applyAdditions = additions: origArgs: result: let
  #    updateArgsWith = newArgs:
  #      if isFunction newArgs
  #      then newArgs origArgs
  #      else newArgs;

  #    resSet =
  #      if isFunction result
  #      then mirrorFunctionArgs result result
  #      else result;

  #    # Apply all additions in the additions map
  #    extendedRes =
  #      lib.foldl' (
  #        res: addition:
  #          addition res updateArgsWith
  #      )
  #      resSet (lib.attrValues additions);
  #    # Core extension logic
  #    coreExtender = origArgs: let
  #      result = f origArgs;

  #      # Define the additions to be applied, easily extensible
  #      additions = {
  #        override = newArgs: mimic f (updateArgsWith newArgs);
  #        absorb = newArgs: mimic ritual f (updateArgsWith newArgs);

  #        # Implement `overrideAttrs` which accepts a function (fdrv) to update specific attributes
  #        overrideAttrs = fdrv: mimic f (updateArgsWith (x: x // fdrv x));
  #      };
  #    in
  #      if isAttrs result || isFunction result
  #      then extendedRes
  #      else result;
  #  in
  #    applyAdditions additions origArgs result;
  #in
  #  injectArgsInto coreExtender;

  parseFunc = func:
    if isPath func || lib.isString func
    then import func
    else if isFunction func
    then func
    else assertMsg false "the passed function must be one of: \{lambda; path\}";

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

  simpleFn = {
    d ? 4,
    a,
    c,
    b ? 2,
    ...
  }: {
    inherit a b c d;
    r = a + b + c + d;
  };
  dFu = {
    a_d ? 4,
    b_a,
    c_c,
    d_b ? 2,
    e_path,
    ...
  } @ pargs: let
    args = tools.amb pargs ["a_d" "b_a" "c_c" "d_b" "e_path"];
  in
    with args; {
      inherit a b c d;
      r = a + b + c + d;
    };
in {
  inherit
    testSet
    simpleFn
    dFu
    addOverrides
    self
    autoCall
    mimic
    inputs
    mim
    ;
}
