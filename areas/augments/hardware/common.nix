{ pkgs, ... }: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.libinput.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 1;
    enableNotifications = true;
  };

  systemd.oomd.enable = false;
}
