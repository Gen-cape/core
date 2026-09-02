{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.libinput.enable = true;

  environment.systemPackages = [pkgs.brightnessctl];
}
