{inputs, ...}: {
  imports = [
    (inputs.nixpkgs + "/nixos/modules/installer/scan/not-detected.nix")
    (inputs.nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")
    (inputs.nixpkgs + "/nixos/modules/profiles/headless.nix")
  ];

  boot = {
    loader = {
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        # devices = [ ]; disko handles that
      };
      timeout = 0;
    };
  };
  zramSwap.enable = true;
  services.openssh.enable = true;

  time.timeZone = "Europe/Amsterdam";
  # networking.hostName = "nl-vmnano";

  system.stateVersion = "25.11";
}
