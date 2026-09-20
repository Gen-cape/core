{
  config,
  pkgs,
  ...
}:
let
  # overlayed-pkg = final: prev: {
  #   overlayed-pkg = final.callPackage ./__pkg {};
  # };
in
{
  nixpkgs.overlays = [
    #   overlayed-pkg
  ];
}
