{
  inputs',
  config,
  self,
  pkgs,
  ...
}: let
  selfPath = (builtins.unsafeDiscardStringContext "${self}") + "/areas";
in {
  stylix.targets.waybar.enable = false;
  home.packages = [pkgs.waybar];
  home.file.".config/waybar".source =
    config.lib.file.mkOutOfStoreSymlink
    "${selfPath}/home/john/hyprland/waybar";
}
