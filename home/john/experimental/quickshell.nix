{
  pkgs,
  self',
  inputs',
  ...
}: let
in {
  home.packages = [
    (inputs'.quickshell.packages.default.override
      {
        withWayland = true;
        withPipewire = true;
        withPam = true;
        withHyprland = true;
      })
    # pkgs.kdePackages.qtmultimedia

    # pkgs.kdePackages.qtmultimedia
    # pkgs.libsForQt5.qt5.qtmultimedia
    # pkgs.libsForQt5.qt5.qtgraphicaleffects
    # pkgs.libsForQt5.qmake
    # pkgs.libsForQt5.qt5.qtbase
    # pkgs.libsForQt5.qt5.qttools
    # pkgs.qt5Full
  ];
}
