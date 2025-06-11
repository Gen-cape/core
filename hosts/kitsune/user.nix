{
  pkgs,
  config,
  ...
}: {
  users.users = let
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICY49OgJ2fJMbhpLY+sK54nDmJ3vCElAjqM1lPvf62r4 john@skald"
    ];

    defaultUser = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = authorizedKeys;
    };
  in {
    "root" = defaultUser;
    "vps" =
      defaultUser
      // {
        isNormalUser = true;
        initialPassword = "1234"; # maybe sops later
        extraGroups = ["wheel" "docker" "podman" "users" "systemd-journal" "networkmanager"];
      };
  };
}
