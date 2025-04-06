{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  i18n = let
    defaultLocale = "en_US.UTF-8";
    auxiliary = "ru_RU.UTF-8";
  in {
    inherit defaultLocale;

    extraLocaleSettings = {
      LANG = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_MESSAGES = defaultLocale;

      LC_ADDRESS = auxiliary;
      LC_IDENTIFICATION = auxiliary;
      LC_MEASUREMENT = auxiliary;
      LC_MONETARY = auxiliary;
      LC_NAME = auxiliary;
      LC_NUMERIC = auxiliary;
      LC_PAPER = auxiliary;
      LC_TELEPHONE = auxiliary;
      LC_TIME = auxiliary;
    };

    supportedLocales = mkDefault [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];

    # IME configuration
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-lua
        libsForQt5.fcitx5-qt

        # themes
        fcitx5-material-color
      ];
    };
  };

  time = {
    timeZone = "Europe/Moscow";

    # DualBooting
    #hardwareClockInLocalTime = true;
  };
}
