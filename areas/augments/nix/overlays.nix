{
  config,
  lib,
  mimics,
  ...
}: let
  inherit (lib.trivial) const;

  nixPkg = config.nix.package; # Currently lix
in {
  # Forgive me lord for all of the settings in this file. Lasciate ogne speranza, voi ch'entrate

  nixpkgs.overlays = [
    (const (prev: {
      nixos-rebuild = prev.nixos-rebuild.override {
        nix = nixPkg;
      };

      nix-direnv = prev.nix-direnv.override {
        nix = nixPkg;
      };

      nix-index = prev.nix-index.override {
        nix = nixPkg;
      };
    }))
  ];
}
