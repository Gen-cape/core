{config, ...}: let
in {
  config.modules.ui = {
    desktop = "hyprland";
    useHomeManager = true;
    programs.screenlock.swaylock.enable = true;
    programs.ags.enable = true;
  };
}
