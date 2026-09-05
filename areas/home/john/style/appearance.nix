{pkgs, ...}: {
  # Pointer Cursor (X11 & Wayland/GTK)
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 20;
  };

  # GTK Theme & Icons
  gtk = {
    enable = true;
    gtk4.theme = null;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "kora";
      package = pkgs.kora-icon-theme;
    };
  };
  home.sessionVariables.GTK_THEME = "adw-gtk3-dark";

  # System & Terminal Fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    dejavu_fonts
    adw-gtk3
    kdePackages.breeze
    kdePackages.breeze-icons
  ];

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    "org/gnome/desktop/media-handling" = {
      automount = false;
      automount-open = false;
      autorun-never = true;
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "alacritty";
      exec-arg = "-e";
    };
  };

  # QT
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    Name=Breeze Dark

    [Icons]
    Theme=breeze-dark

    # ${builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"}
  '';
}
