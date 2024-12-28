{pkgs, ...}: let
in {
  home.packages = [
    pkgs.gotop
    pkgs.activate-linux
  ];
}
