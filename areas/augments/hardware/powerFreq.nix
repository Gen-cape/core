{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.core.powerManagement.enable = mkEnableOption "Enable power management services.";
  config = mkIf config.core.powerManagement.enable {
    powerManagement.enable = true;
    services.thermald.enable = true;
    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          energy_perfomance_preference = "power";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          energy_perfomance_preference = "perfomance";
          turbo = "auto";
        };
      };
    };
  };
}
