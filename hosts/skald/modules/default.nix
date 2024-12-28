{...}: let
in {
  imports = [
    ./env.nix
    ./machine.nix
    ./ui.nix
    ./theme.nix
  ];
}
