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
  selfPath = (builtins.unsafeDiscardStringContext "${self}") + /areas;
  systemSet = {
    inherit withSystem;
    basicArgs = {
      inherit self inputs;
      inherit (inputs.riptide) mimics;
    };
  };

  augmentsRoot = selfPath + /augments;
  homeModulesRoot = selfPath + /home;

  baseAugments = fzf augmentsRoot "\.nix !__";
  baseHomeModules = name: fzf (homeModulesRoot + /${name}) "\.nix !__";

  mkSystem = inputs.riptide.mimics.mkSystem systemSet;
  mkHome = inputs.riptide.mimics.mkHome systemSet;
in {
  flake = {
    nixosConfigurations = {
      skald = mkSystem {
        system = "x86_64-linux";
        modules = [
          baseAugments
        ];
      };
    };
    homeConfigurations = {
      "john@skald" = mkHome {
        system = "x86_64-linux";
        modules = [
          (baseHomeModules "john")
        ];
      };
    };
    # thats some wicked things, binds each home-system (in case home-manager acts standalone)
  };
}
