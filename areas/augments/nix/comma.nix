{
  config,
  lib,
  pkgs,
  ...
}: {
  comma.enable = true;
  environment.systemPackages = [pkgs.comma.override {nix-index-unwrapped = config.programs.nix-index.package;}];

  programs = {
    command-not-found.enable = lib.mkForce false;
    nix-index.enable = true;
  };
}
