{pkgs, ...}: let
  flakePath = "/home/john/core"; # path to the system flake
in {
  environment.variables.flakePath = flakePath;

  environment.systemPackages = [pkgs.nh];
  programs.nh = {
    enable = true;
    package = pkgs.nh;
    flake = flakePath;

    clean = {
      enable = false; # nix-auto-gc is enabled on all systems, nh isn't.
      dates = "weekly"; # run gc on the store weekly?
    };
  };
}
