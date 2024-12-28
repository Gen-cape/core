{
  lib,
  mimics,
  ...
}: let
  inherit (builtins) filter map toString elem all elemAt isPath isFunction attrNames intersectAttrs isAttrs;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix hasInfix splitString;
  inherit (lib) toList;
  inherit (lib.lists) concatLists flatten;
  # inherit (mimics.tools) recipe autoArgs;
  inherit (mimics) recipe autoArgs;

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
in {
  inherit
    getModulesFzf
    getFzf
    listRecursive
    listRecursiveCumulative
    listRecursiveBase
    moduleRequest
    ;
}
