{
  config,
  lib,
  ...
}: let
  inherit (lib.types) mkEnableOption mkIf mkOption;
  inherit (lib) mkMerge;
  cfg = config.core.batteryThreshold;
in {
  options.core = {
    batteryThreshold.enable = mkEnableOption "Enable battery charge threshold.";
    batteryThreshold.value = mkOption {
      type = lib.types.int;
      default = 80;
      description = "The battery charge threshold.";
    };
  };
  config = mkMerge [
    (mkIf (lib.powerManagement.enable) {
      systemd.sleep.extraConfig = ''
        AllowSuspend=yes
      '';
      systemd.services.battery = {
        enable = true;
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        description = "Set the battery charge threshold.";
        serviceConfig = {
          StartLimitBurst = "0";
          Type = "oneshot";
          User = "root";
          Restart = "on-failure";
          ExecStart = "/bin/sh -c 'echo ${cfg.value} > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
        };
      };
    })
    {
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };
      environment.systemPackages = with lib.pkgs; [
        cpupower
      ];
    }
  ];
}
