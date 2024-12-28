{
  config,
  pkgs,
  ...
}: let
in {
  config = {
    modules = {
      usrEnv.brightness.enable = true;
      system.boot = {
        saneDefaults.enable = true;
        kernel = pkgs.linuxPackages_xanmod_latest;
        enableKernelTweaks = true;
        opinionatedGrub = true;
      };
      usrEnv.programs.launchers = {
        rofi.enable = true;
        anyrun.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      yazi
      networkmanager
      fish
      zoxide
      #foot
      alacritty
    ];
    boot.plymouth.enable = true;
  };
}
