{
  config,
  pkgs,
  ...
}: let
  amnezia-vpn = final: prev: {
    amnezia-vpn = final.callPackage ./__amnezia-vpn {};
  };
in {
  nixpkgs.overlays = [
    amnezia-vpn
  ];
}
