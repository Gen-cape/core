{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options = {
    #modules.usrEnv.brightness.enable = mkEnableOption "manage brightness";
    modules.system.autoLogin = mkEnableOption "autoLogin";
    modules.usrEnv.programs.launchers = {
      anyrun.enable = mkEnableOption "anyrun";
      rofi.enable = mkEnableOption "rofi";
      tofi.enable = mkEnableOption "tofi";
    };
    modules.usrEnv.programs.screenlock = {
      swaylock.enable = mkEnableOption "swaylock" // {default = true;};
    };
  };
}
