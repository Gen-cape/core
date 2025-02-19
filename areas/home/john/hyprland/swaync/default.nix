{
  config,
  self,
  pkgs,
  ...
}: let
  selfPath = (builtins.unsafeDiscardStringContext "${self}") + "/areas";
in {
  stylix.targets.waybar.enable = false;
  home.packages = [pkgs.swaynotificationcenter];
  home.file.".config/swaync".source =
    config.lib.file.mkOutOfStoreSymlink
    "${selfPath}/home/john/hyprland/swaync";
}
