{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
  ];
}
