{pkgs, ...}: {
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # in megabytes
      priority = 0;
    }
  ];

  programs.kdeconnect.enable = true;

  # Webcam killswitch
  boot.blacklistedKernelModules = ["uvcvideo"];
}
