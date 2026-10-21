{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.libinput.enable = true; # touchpad

  # (Vial)
  services.udev = {
    packages = with pkgs; [via vial];
  };

  # Memory
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # in megabytes
      priority = 0;
    }
  ];
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    enableNotifications = true;
  };
  systemd.oomd.enable = false;
  zramSwap = {
    enable = true;
    priority = 100;
  };

  # caps is f13
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
     KEYBOARD_KEY_3a=f13

    evdev:input:b0003*
     KEYBOARD_KEY_70039=f13
  '';

  programs.kdeconnect.enable = true;

  # Webcam killswitch
  boot.blacklistedKernelModules = ["uvcvideo"];
}
