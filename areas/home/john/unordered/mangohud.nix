{
  pkgs,
  inputs',
  ...
}: let
  fresh = inputs'.fresh.legacyPackages;
in {
  programs.mangohud = {
    enable = true;
    package = fresh.mangohud;
  };
}
