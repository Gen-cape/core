{
  withSystem,
  inputs,
  self,
  lib,
  ...
}: let
  inherit (inputs.riptide) mimics;
  inherit (mimics) getModules fzf;
  inherit (lib.lists) singleton concatLists flatten;
  systemSet = {
    inherit withSystem;
    basicArgs = {
      inherit self inputs;
      inherit (inputs.riptide) mimics;
    };
  };

  mkSystem = inputs.riptide.mimics.mkSystem systemSet;
  mkHome = inputs.riptide.mimics.mkHome systemSet;
in {
  flake = {
    nixosConfigurations = {
      skald = mkSystem {
        system = "x86_64-linux";
        modules = [];
      };
    };
    homeConfigurations = {
      "john@skald" = mkHome {
        system = "x86_64-linux";
        modules = [
        ];
      };
    };
    # thats some wicked things, binds each home-system (in case home-manager acts standalone)
  };
}
