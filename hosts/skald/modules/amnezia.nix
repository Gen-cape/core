{inputs', ...}: let
  freshest =
    inputs'.fresh.legacyPackages;
in {
  programs.amnezia-vpn = {
    enable = true;
    package = freshest.amnezia-vpn;
  };
}
