{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self nixpkgs;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.lists) singleton concatLists;
  inherit (lib.modules) mkDefault;

  mkNixos = lib.nixosSystem;
  mkSystem = otherArgs @ {
    withSystem,
    system,
    hostname,
    ...
  }:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      mkNixos {
        specialArgs = recursiveUpdate {
          inherit lib inputs self inputs' self';
        } (otherArgs.specialArgs or {});

        modules = concatLists [
          (singleton {
            networking.hostName = otherArgs.hostname;
            nixpkgs = {
              hostPlatform = mkDefault otherArgs.system;
              flake.source = nixpkgs.outPath;
            };
          })
          (otherArgs.modules or [])
        ];
      });
in {
  inherit mkSystem mkNixos;
}
