{pkgs, ...}: {
  users.users = {
    john = {
      isNormalUser = true;
      createHome = true;
      home = "/home/john";

      shell = pkgs.fish;

      initialHashedPassword = "$y$j9T$fKO6wXRW2QGevOeV.bLa0.$ffoiNdmKJnQGUwHrg.12NE6.sFNUu.Fa1kpUvL8aJD/";

      extraGroups = [
        "wheel" # sudo, trusted-user Nix
        "networkmanager" # wifi/vpn toggles without root
        "i2c" # Vial
        "video" # Brightness
        "input" # evtest, kanata, bongo cat
      ];
    };
    root.hashedPassword = "*";
  };

  system.stateVersion = "24.05";
}
