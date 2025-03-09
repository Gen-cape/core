{
  config,
  pkgs,
  lib,
  ...
}: {
  stylix.targets.waybar.enable = false;
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = lib.mkForce 0.5;

        padding = {
          x = 10;
          y = 10;
        };

        decorations = "full";
      };
    };
  };
}
