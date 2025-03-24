{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "adw-gtk3-dark";
      package = lib.mkForce pkgs.adw-gtk3;

      # name = "WhiteSur-Dark-solid-hdpi";
      # package = pkgs.whitesur-gtk-theme;

      # name = "Orchis-Dark";
      # package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Flat-Remix-Blue-Dark";
      package = pkgs.flat-remix-icon-theme;

      # name = "WhiteSur-dark";
      # package = pkgs.whitesur-icon-theme;
    };
  };
}
