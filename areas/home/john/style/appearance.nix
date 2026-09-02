{pkgs, ...}: {
  # Pointer Cursor (X11 & Wayland/GTK)
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 20;
  };

  # GTK Theme & Icons
  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
      size = 10;
    };
  };

  # System & Terminal Fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    dejavu_fonts
  ];
}
