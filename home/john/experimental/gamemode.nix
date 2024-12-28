{
  pkgs,
  self',
  inputs',
  ...
}: let
in {
  home.packages = [
    pkgs.gamemode
  ];
}
