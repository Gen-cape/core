{
  withSystem,
  inputs,
  self,
  ...
}: let
  inherit (inputs.riptide) mimics;
  inherit (mimics) fzf;
  selfPath = (builtins.unsafeDiscardStringContext "${self}") + "/areas";

  systemSet = {
    inherit withSystem;
    basicArgs = {
      inherit self inputs;
      inherit (inputs.riptide) mimics;
    };
  };

  augmentsRoot = selfPath + "/augments";
  homeModulesRoot = selfPath + "/home";

  defaultRule = "\.nix !__ \.nix";
  baseAugments = fzf (/. + augmentsRoot) defaultRule;
  mkForUser = name: fzf (/. + (homeModulesRoot + "/${name}")) defaultRule;
  mkForHost = host: fzf (./. + /${host}) defaultRule;

  mkSystem = inputs.riptide.mimics.mkSystem systemSet;
  mkHome = inputs.riptide.mimics.mkHome systemSet;
in {
  flake = {
    DEBUG = {
      inherit baseAugments;
    };
    nixosConfigurations = {
      skald = mkSystem {
        hostname = "skald";
        system = "x86_64-linux";
        modules = [
          (mkForHost "skald")
          baseAugments
          inputs.nix-gaming.nixosModules.pipewireLowLatency
          inputs.chaotic.nixosModules.default
          inputs.nur.modules.nixos.default
          # inputs.home-manager.nixosModules.home-manager one day, when ill tinker less
        ];
      };
    };
    homeConfigurations = {
      "john@skald" = mkHome {
        username = "john";
        system = "x86_64-linux";
        modules = [
          (mkForUser "john")
          inputs.chaotic.homeManagerModules.default
        ];
      };
    };
    # thats some wicked things, binds each home-system (in case home-manager acts standalone)
  };
}
