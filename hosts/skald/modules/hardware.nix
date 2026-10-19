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
