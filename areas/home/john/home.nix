{
  imports = [
    ./branches.nix
  ];

  config = {
    home = {
      username = "john";
      homeDirectory = "/home/john";

      stateVersion = "24.05";
    };

    systemd.user.startServices = "sd-switch";
  };
}
