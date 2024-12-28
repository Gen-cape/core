{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types;
in {
  config = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    boot.kernel.sysctl = mkIf config.zramSwap.enable {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "v.page-cluster" = 0;
    };

    #networking.timeServers = [
    #  "0.nixos.pool.ntp.org"
    #  "1.nixos.pool.ntp.org"
    #  "2.nixos.pool.ntp.org"
    #  "3.nixos.pool.ntp.org"
    #];

    environment.systemPackages = [pkgs.openntpd];

    #services = {
    #  openntpd = {
    #    enable = true;
    #    extraConfig = ''
    #      listen on 127.0.0.1
    #      listen on ::1
    #    '';
    #  };

    #  logrotate.settings.header = {
    #    global = true;
    #    dateext = true;
    #    dateformat = "-%Y-%m-%d";
    #    nomail = true;
    #    missingok = true;
    #    copytruncate = true;

    #    # rotation frequency
    #    priority = 1;
    #    frequency = "weekly";
    #    rotate = 7; # every 7 days
    #    minage = 7; # less than 7 days old = NO TOUCHY

    #    compress = true;
    #    compresscmd = "${lib.getExe' pkgs.zstd "zstd"}";
    #    compressoptions = " -Xcompression-level 10";
    #    compressext = "zst";
    #    uncompresscmd = "${lib.getExe' pkgs.zstd "unzstd"}";
    #  };

    #  fwupd = {
    #    enable = true;
    #    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    #  };

    #  thermald.enable = true;

    #  #chrony.enable = false;

    #  #timesyncd = {
    #  #  enable = true;
    #  #  servers = config.networking.timeServers;
    #  #  extraConfig = ''
    #  #    PollIntervalMinSec=128
    #  #  '';
    #  #};
    #};
  };
}
