{
  withSystem,
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.riptide.mimics) getModules;
    inherit (lib.lists) singleton concatLists flatten;

    mkSystem = inputs.riptide.mimics.mkSystem {
      inherit withSystem self inputs;
      inherit (inputs.nixpkgs) outPath;
    };

    rootModules = ../areas/modules;

    heartModules = rootModules + /core;

    equipment = heartModules + /equipment;

    laptop = equipment + /laptop;
    graphical = equipment + /graphical;
    workstation = equipment + /workstation;
    experimental = equipment + /experimental;

    options = rootModules + /options;
    baseSystem = heartModules + /system;

    hm = inputs.home-manager.nixosModules.home-manager;
    homePath = ../home;

    homes = [hm homePath];

    getHostModules = hostname: {
      modules ? [options baseSystem],
      roles ? [],
      extraModules ? [],
    } @ otherArgs:
      flatten (
        concatLists [
          (singleton ./${hostname}/host.nix)

          (map (path: getModules {inherit path;}) (concatLists [modules roles]))

          otherArgs.extraModules
        ]
      );
  in {
    skald = mkSystem {
      hostname = "skald";
      system = "x86_64-linux";
      modules = getHostModules "skald" {
        roles = [laptop graphical workstation experimental];
        extraModules = [homes];
      };
    };
  };
}
