{
  pkgs,
  self,
  config,
  ...
}: let
  selfPath = (builtins.unsafeDiscardStringContext "${self}") + "/areas";
in {
  home.packages = [pkgs.rofi-wayland];

  home.file.".config/rofi".source =
    config.lib.file.mkOutOfStoreSymlink
    "${selfPath}/home/john/hyprland/rofi";
}
