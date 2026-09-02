{
  pkgs,
  inputs,
  ...
}: {
  programs.mango = {
    enable = true;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    libnotify
    foot # or your preferred terminal
    alacritty
  ];
}
