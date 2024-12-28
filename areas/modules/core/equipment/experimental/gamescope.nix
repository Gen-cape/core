{
  config,
  pkgs,
  lib,
  inputs',
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  #config = mkIf prg.gaming.gamescope.enable {
  config = {
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope; # the default, here in case I want to override it
      #package = inputs'.nixpkgs-stable.legacyPackages.gamescope; # the default, here in case I want to override it
    };

    # workaround attempt for letting gamescope bypass YAMA LSM
    # doesn't work, but doesn't hurt to keep this here
    security.wrappers.gamescope = {
      owner = "root";
      group = "root";
      source = "${config.programs.gamescope.package}/bin/gamescope";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };
    environment.systemPackages = with pkgs; [gamescope];
    #nixpkgs.config.packageOverrides = pkgs: {
    #  steam = pkgs.steam.override {
    #    extraPkgs = pkgs:
    #      with pkgs; [
    #        xorg.libXcursor
    #        xorg.libXi
    #        xorg.libXinerama
    #        xorg.libXScrnSaver
    #        libpng
    #        libpulseaudio
    #        libvorbis
    #        stdenv.cc.cc.lib
    #        libkrb5
    #        keyutils
    #      ];
    #  };
    #};
    #hardware.graphics.extraPackages = [
    #  pkgs.amdvlk
    #];

    ## To enable Vulkan support for 32-bit applications, also add:
    #hardware.graphics.extraPackages32 = [
    #  pkgs.driversi686Linux.amdvlk
    #];

    ## Force radv
    #environment.variables.AMD_VULKAN_ICD = "RADV";
    ## Or
    #environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };
}
