{
  pkgs,
  inputs',
  ...
}: {
  home.packages = with pkgs; [
    affine
    onlyoffice-desktopeditors
    telegram-desktop
    satty
    jj-fzf

    inputs'.riptide.packages.drvinter
    inputs'.riptide.packages.tmsufolders
    inputs'.riptide.packages.tmsufs
    inputs'.riptide.packages.quest
    inputs'.riptide.packages.keep-alive
    inputs'.riptide.packages.tray-tui
  ];
}
