{pkgs, ...}: {
  home.packages = with pkgs; [
    wpsoffice
    onlyoffice-desktopeditors
  ];
}
