{pkgs, ...}: let
in {
  home.packages = [pkgs.rofi-wayland];
}
