{
  pkgs,
  lib,
  ...
}: {
  services.xserver.videoDrivers = lib.mkDefault ["modesetting"];
  hardware.amdgpu.initrd.enable = lib.mkDefault true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  # (Vial)
  services.udev = {
    extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
    packages = with pkgs; [via vial];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [vial];
}
