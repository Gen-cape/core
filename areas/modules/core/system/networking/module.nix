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

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # network tools that are helpful and nice to have
  boot.kernelModules = ["af_packet"];
  environment.systemPackages = with pkgs; [
    mtr
    tcpdump
    traceroute
  ];

  networking = {
    # generate a unique hostname by hashing the hostname
    # with md5 and taking the first 8 characters of the hash
    # this is especially helpful while using zfs but still
    # ensures that there will be a unique hostId even when
    # we are not using zfs
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # dns
    nameservers = [
      # cloudflare, yuck
      # shares data
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"

      # quad9, said to be the best
      # shares *less* data
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
  };

  ## enable wireless database, it helps with finding the right channels
  hardware.wirelessRegulatoryDatabase = true;
}
