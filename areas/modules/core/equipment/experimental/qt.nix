{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gnome";
  };

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
  ];
}
