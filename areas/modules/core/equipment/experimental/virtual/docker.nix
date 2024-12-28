{...}: let
in {
  virtualisation = {
    podman = {
      enable = true;
    };
    docker = {
      enable = true;
    };
  };
}
