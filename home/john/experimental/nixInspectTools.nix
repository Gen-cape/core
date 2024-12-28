{
  pkgs,
  self',
  ...
}: let
in {
  home.packages = [
    pkgs.nix-melt
    pkgs.nix-inspect
  ];
}
