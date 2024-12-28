{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types;

  cfg = config.modules.usrEnv.brightness;
in {
  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];
    #systemd = {
    #  services."brightness-brightnessd" = {
    #    description = "systemd managment";

    #    wantedBy = ["default.target"];
    #    partOf = ["graphical-session.target"];

    #    #serviceConfig = {
    #    #  Type = "${cfg.service.type}";
    #    #  ExecStart = "${lib.getExe cfg.package}";
    #    #  Restart = "never";
    #    #  RestartSec = "5s";
    #    #};
    #  };
    #};
  };
}
