{
  pkgs,
  config,
  lib,
  ...
}: {
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["wlr" "gtk"];
      mango = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
      hyprland = {
        default = ["hyprland" "gtk"];
      };
    };
  };

  # Hyprland
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  #   withUWSM = true;
  # };

  # MangoWM & Session
  programs.mango.enable = true;
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      mango = {
        prettyName = "Mango";
        comment = "Mango Wayland Compositor";
        binPath = "${lib.getExe pkgs.mango}";
      };
    };
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  # Display Manager / Greeter
  services.displayManager.noctalia-greeter = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    settings = {
      user.default = "john";
      keyboard.layout = "us";
      cursor.size = 20;
      appearance = {
        scheme = "Synced";
        password_style = "random";
        hide_logo = true;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
