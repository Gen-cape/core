{
  home = {
    username = "john";
    homeDirectory = "/home/john";
    stateVersion = "24.05";
  };

  nixpkgs.config.allowUnfree = true;

  systemd.user.startServices = "sd-switch";
}
