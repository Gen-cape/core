{
  pkgs,
  lib,
  ...
}: let
in {
  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraEnv = {
        #MANGOHUD = true;
        #SDL_VIDEODRIVER = "x11";
      };
      extraPkgs = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
  environment.systemPackages = [
    #pkgs.protonup-qt
    pkgs.mangohud
    pkgs.gamemode
    pkgs.pkgsi686Linux.gperftools
  ];

  services.xserver.videoDrivers = lib.mkDefault ["modesetting"];
  hardware.amdgpu.initrd.enable = lib.mkDefault true;
}
