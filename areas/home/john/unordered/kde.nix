{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatLists;
in {
  config = {
    home.packages = concatLists [
      ## Will add more packages if I find out there are some apps that do not work.
      (with pkgs; [
        libsForQt5.ffmpegthumbs #kdePackages are buggy, use libsForQt5 instead
        libsForQt5.qtwayland
        libsForQt5.qtsvg
        libsForQt5.kiconthemes
        libsForQt5.kdf
        libsForQt5.kio-extras
        libsForQt5.kio-admin
        libsForQt5.plasma-integration
        libsForQt5.kdegraphics-thumbnailers
        libsForQt5.kservice
        libsForQt5.kfind
        libsForQt5.kdbusaddons
        libsForQt5.kfilemetadata
        libsForQt5.kconfig
        libsForQt5.kcoreaddons
        libsForQt5.kguiaddons
        libsForQt5.ki18n
        libsForQt5.kitemviews
        libsForQt5.kwidgetsaddons
        libsForQt5.kwindowsystem
        # ark
        kdePackages.full
      ])
    ];
  };
}
