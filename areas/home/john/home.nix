{pkgs, ...}: {
  home = {
    username = "john";
    homeDirectory = "/home/john";
    stateVersion = "24.05";
  };

  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.lix;

  systemd.user.startServices = "sd-switch";
}
