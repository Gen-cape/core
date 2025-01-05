{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [];

  config = {
    nix.package = mkForce pkgs.lix;
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = _: true;

    home = {
      username = "john";
      homeDirectory = "/home/john";

      stateVersion = "24.05";
    };

    systemd.user.startServices = "sd-switch";
  };
}
