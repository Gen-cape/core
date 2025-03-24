{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Sweet-Dark";
      package = lib.mkForce pkgs.sweet;

      # name = "WhiteSur-Dark-solid-hdpi";
      # package = pkgs.whitesur-gtk-theme;

      # name = "Orchis-Dark";
      # package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Sweet-Rainbow";
      package = pkgs.sweet-folders;

      # name = "WhiteSur-dark";
      # package = pkgs.whitesur-icon-theme;
    };
  };
}
