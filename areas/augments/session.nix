{pkgs, ...}: {
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXPKGS_ALLOW_UNFREE = "1";
    EDITOR = "nvim";
    NIX_AUTO_RUN = "1";
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs.umbriel.enable = true; # also handles portals, so gtk is fallback

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    settings = {
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
