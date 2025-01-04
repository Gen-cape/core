{
  imports = [
    ./branches.nix
  ];

  config = {
    home = {
      username = "john";
      homeDirectory = "/home/john";
      extraOutputsToInstall = ["doc" "devdoc"];

      stateVersion = "24.05";
    };

    systemd.user.startServices = "sd-switch";
  };
}
