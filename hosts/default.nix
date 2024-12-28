{
  lib,
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) qol;
    inherit (qol.builders) mkSystem;
    inherit (qol.modules) getModules;
    inherit (lib.lists) concatLists flatten singleton;

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
      inherit withSystem;
      hostname = "skald";
      system = "x86_64-linux";
      modules = getHostModules "skald" {
        roles = [laptop graphical workstation experimental];
        extraModules = [homes];
      };
    };
  };
}
