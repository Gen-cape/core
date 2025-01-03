{
lib,
config,
pkgs,
...
}: let
  inherit (lib.modules) mkDefault;
in {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      powertop

    ];

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

    hardware.acpilight.enable = true;

    services = {
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };

      acpid = {
        enable = true;
        logEvents = true;
      };

      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            energy_perfomance_preference = "power";
            turbo = "never";
          };

          charger = {
            governor = "perfomance";
            energy_perfomance_preference = "perfomance";
            turbo = "auto";
          };
        };
      };
      power-profiles-daemon.enable = false;

    };
  };
}
