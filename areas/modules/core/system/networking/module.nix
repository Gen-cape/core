{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce mkDefault;
in {
  imports = [
  ];

  systemd.services.NetworkManager-wait-online.enable = false;

  # network tools that are helpful and nice to have
  boot.kernelModules = ["af_packet"];
  environment.systemPackages = with pkgs; [
    mtr
    tcpdump
    traceroute
  ];

  # Ensure systemd-resolved service is properly enabled
  systemd.services.systemd-resolved.enable = true;

  ## enable wireless database, it helps with finding the right channels
  hardware.wirelessRegulatoryDatabase = true;
}
