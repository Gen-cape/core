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
in {
  inherit
    getAllModules
    getModules
    ;
}
