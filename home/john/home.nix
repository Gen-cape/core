{
  imports = [
    ./branches.nix
  ];

  config = {
    home = {
      username = "john";
      homeDirectory = "/home/john";
      extraOutputsToInstall = ["doc" "devdoc"];

      # This is, and should remain, the version on which you have initiated
      # the home-manager configuration. Similar to the `stateVersion` in the
      # NixOS module system, you should not be changing it.
      # I will personally strangle every moron who just puts nothing but "DONT CHANGE" next
      # to this value
      stateVersion = "24.05";
    };

    # reload system units when changing configs
    systemd.user.startServices = "sd-switch"; # or "legacy" if "sd-switch" breaks again
  };
}
