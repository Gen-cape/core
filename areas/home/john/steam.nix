{
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
    programs.gamescope = {
      enable = true;
      package = inputs.chaotic.packages."${pkgs.system}".gamescope_git;
    };

    #programs.gamescope.capSysNice = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server

      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libgdiplus
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };

      extraCompatPackages = [
        inputs.chaotic.packages."${pkgs.system}".proton-ge-custom
      ];
    };
  };
}
