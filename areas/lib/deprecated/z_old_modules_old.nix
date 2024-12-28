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
    downwardsBlock ? [],
  }: let
    processCondition = {
      path,
      func,
      lst,
    }: (
      if (toList lst) != []
      then all (x: x) (map (expr: (func expr (toString path))) (toList lst))
      else true
    );
    dropIgnored = path: (processCondition {
      inherit path;
      func = pattern: obj: !hasInfix pattern obj;
      lst = ignoreExpr;
    });
    forceRequired = path: (processCondition {
      inherit path;
      func = pattern: obj: hasInfix pattern obj;
      lst = forceExpr;
    });
    forceEnding = path: (processCondition {
      inherit path;
      func = pattern: obj: hasSuffix pattern obj;
      lst = forceSuffix;
    });
    dropEnding = path: (processCondition {
      inherit path;
      func = pattern: obj: !hasSuffix pattern obj;
      lst = ignoreSuffix;
    });
    forceLimiterFodler = path: let
      splited = splitString "/" path;
      forcedFolder = toList downwardsBlock;
    in (
      if (forcedFolder != [])
      then (elem (elemAt splited ((lib.lists.length splited) - 2)) forcedFolder)
      else true
    );
  in
    pipe (listFilesRecursive path) [
      (lst: map toString lst)
      (filter (
        path:
          dropIgnored path
          && dropEnding path
          && forceRequired path
          && forceEnding path
          && !elem path ignoredPaths
          && forceLimiterFodler path
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
    requestSep ? " ",
  }:
    flatten (
      concatLists [
        (map (expr:
          getModulesRequest {
            inherit path ignoredPaths forceSuffix ignoreSuffix ignoreExpr downwardsBlock;
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
