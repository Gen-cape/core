{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # "${nixpkgs}/nixos/modules/installer/not-detected.nix"
    # "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"

    # ./disk-config.nix # if you dont autoparse it, i do :)
    # ./hardware-configuration.nix # the same story
  ];
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.neovim
    pkgs.jujutsu
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVRUNm22zWYnurMkriEBC5Q1EZGEJcbwO7vJDftTPc0"
  ];

  system.stateVersion = "25.05";
}
