{
  pkgs,
  inputs,
  ...
}: {
  programs.mango = {
    enable = true;
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      mango = {
        prettyName = "Mango";
        comment = "Mango Wayland Compositor";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };
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
