{
  self',
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) plymouth;
  inherit (lib) mkIf mkAfter;
in {
  #config = mkIf config.boot.plymouth.enable {
  config = {
    # configure plymouth theme
    # <https://github.com/adi1090x/plymouth-themes>
    #boot.plymouth = let
    #  pack = 3;
    #  theme = "hud_3";
    #in {
    #  themePackages = [(self'.packages.plymouth-themes.override {inherit pack theme;})];

    #  inherit theme;
    #};

    boot.plymouth = let
      themeName = "deus_ex";
    in {
      enable = true;
      theme = themeName;
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [themeName];
        })
      ];
    };

    # make plymouth work with sleep
    powerManagement = {
      powerDownCommands = ''
        ${plymouth} --show-splash
      '';
      resumeCommands = ''
        ${plymouth} --quit
      '';
    };
  };
}
