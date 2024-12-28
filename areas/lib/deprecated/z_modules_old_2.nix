{lib, ...}: let
  inherit (builtins) filter map toString elem all isString elemAt;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix hasInfix splitString;
  inherit (lib) pipe toList;
  inherit (lib.lists) concatLists flatten singleton length;

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

  getModulesRequest = {
    path,
    ignoredPaths ? [],
    forceSuffix ? [],
    forceExpr ? [],
    ignoreSuffix ? [],
    ignoreExpr ? [],
    downwardsLock ? [],
    downwardsBlock ? [],
    lockDepth ? 1,
  }: let
    processCondition = {
      path,
      func,
      lst,
    } @ args: (
      if (toList lst) != []
      then all (x: x) (map (expr: (func {inherit expr args;})) (toList lst))
      else true
    );
    dropIgnored = {
      expr,
      args,
    }: (!hasInfix expr (toString args.path));
    forceRequired = {
      expr,
      args,
    }: (hasInfix expr (toString args.path));
    forceEnding = {
      expr,
      args,
    }: (hasSuffix expr (toString args.path));

    dropEnding = {
      expr,
      args,
    }: (!hasSuffix expr (toString args.path));

    forceLimiterFolder = {
      expr,
      args,
    }: let
      splited = splitString "/" args.path;
      dir = (lib.lists.length splited) - lockDepth - 1;
    in
      if (dir < 0)
      then false
      else elem (elemAt splited dir) (toList args.lst);
    forceForbidFolder = {
      expr,
      args,
    }: let
      splited = splitString "/" args.path;
      dir = (lib.lists.length splited) - lockDepth - 1;
    in
      if (dir < 0)
      then false
      else !elem (elemAt splited dir) (toList args.lst);
  in
    pipe (listFilesRecursive path) [
      (lst: map toString lst)
      (filter (
        path:
          processCondition {
            inherit path;
            func = dropIgnored;
            lst = ignoreExpr;
          }
          && processCondition {
            inherit path;
            func = forceRequired;
            lst = forceExpr;
          }
          && processCondition {
            inherit path;
            func = forceEnding;
            lst = forceSuffix;
          }
          && processCondition {
            inherit path;
            func = dropEnding;
            lst = ignoreSuffix;
          }
          && !elem path ignoredPaths
          && processCondition {
            inherit path;
            func = forceLimiterFolder;
            lst = downwardsLock;
          }
          && processCondition {
            inherit path;
            func = forceForbidFolder;
            lst = downwardsBlock;
          }
      ))
    ];

  # Caution: it MERGES requests
  getModulesFzf = {
    path,
    requests ? "",
    ignoredPaths ? [],
    forceSuffix ? [],
    ignoreSuffix ? [],
    ignoreExpr ? [],
    additionalPaths ? [],
    downwardsBlock ? [],
    downwardsLock ? [],
    requestSep ? " ",
    lockDepth ? 1,
  }:
    flatten (
      concatLists [
        (map (expr:
          getModulesRequest {
            inherit path ignoredPaths forceSuffix ignoreSuffix ignoreExpr downwardsBlock downwardsLock lockDepth;
            forceExpr =
              if requestSep != ""
              then splitString requestSep expr
              else expr;
          })
        (toList requests))
        additionalPaths
      ]
    );
in {
  inherit getAllModules getModules getModulesRequest getModulesFzf;
}
