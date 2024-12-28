{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  # time = {
  #   timeZone = "Europe/Moscow";
  #
  #   # DualBooting
  #   #hardwareClockInLocalTime = true;
  # };
  #
  # i18n.defaultLocale = "en_US.UTF-8";
  # i18n.supportedLocales = [
  #   "C.UTF-8/UTF-8"
  #   "en_US.UTF-8/UTF-8"
  #   "ru_RU.UTF-8/UTF-8"
  # ];
  #
  # # Configure keymap
  # services.xserver = {
  #   xkb.layout = "us,ru";
  #   xkb.variant = "";
  #   xkb.options = "grp:alt_shift_toggle";
  # };
}
