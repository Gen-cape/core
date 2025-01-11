{
  pkgs,
  self',
  inputs',
  lib,
  ...
}: let
in {
  environment.systemPackages = [
  ];

  services.kanata = {
    enable = true;
    #package = inputs'.nixpkgs-stable.legacyPackages.kanata;
    keyboards.laptop = {
      # devices = [
      # "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      # "/dev/input/by-path/pci-0000\:04:00.3-usb-0\:2:1.0-event-kbd"
      # "/dev/input/by-path/pci-0000\:04:00.3-usbv2-0\:2:1.0-event-kbd"
      # "/dev/input/by-path/pci-0000\:06:00.3-usb-0\:1.3\:1.0-event-kbd"
      # "/dev/input/by-path/pci-0000\:06:00.3-usbv2-0\:1.3\:1.0-event-kbd"
      # ];
      extraDefCfg = ''
        process-unmapped-keys yes
        concurrent-tap-hold yes
        movemouse-inherit-accel-state yes
        movemouse-smooth-diagonals yes
      '';
      config =
        builtins.readFile ./kanata.kbd
        + (import ./__kanata-test.nix {inherit lib;});
      #+ builtins.readFile ./kanata-seq-obsidian.kbd;
    };
  };

  boot.kernelModules = ["uinput"];
}
