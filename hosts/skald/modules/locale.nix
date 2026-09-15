{
  pkgs,
  lib,
  ...
}: {
  time.timeZone = "Europe/Moscow";

  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = lib.mkDefault [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-lua
        libsForQt5.fcitx5-qt
        fcitx5-material-color
      ];
    };
  };
}
