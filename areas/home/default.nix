{
  inputs',
  self',
  self,
  config,
  lib,
  ...
}: let
  inherit (self) inputs;
  inherit (lib.attrsets) genAttrs;
  inherit (inputs.riptide) mimics;

  specialArgs = {inherit inputs self inputs' self' mimics;};
in {
  # RESERVED for the time id want to manage it as a nixos module (guess while ill tinker less)
  # home-manager = {
  #   verbose = true;
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #
  #   extraSpecialArgs = specialArgs;
  #
  #   users = genAttrs config.core.users (name: ./${name} + /home.nix);
  # };
}
