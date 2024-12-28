{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption mkOption types;

  cfg = config.modules.system.boot;
in {
  config.users.users = {
    john = {
      isNormalUser = true;
      createHome = true;
      home = "/home/john";

      shell = pkgs.fish;

      initialHashedPassword = "$y$j9T$fKO6wXRW2QGevOeV.bLa0.$ffoiNdmKJnQGUwHrg.12NE6.sFNUu.Fa1kpUvL8aJD/";

      extraGroups = [
        "wheel"
        "systemd-journal"
        "audio"
        "video"
        "input"
        "plugdev"
        "lp"
        "tss"
        "power"
        "nix"
        "network"
        "networkmanager"
        "wireshark"
        "mysql"
        "docker"
        "podman"
        "git"
        "libvirtd"
      ];
    };
    root.hashedPassword = "*";
  };
}
