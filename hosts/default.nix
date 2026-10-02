{
  inputs,
  self,
  ...
}: let
  gate = inputs.gate.lib;
  system = "x86_64-linux";

  areas = self + "/areas";

  baseAugments = gate.importModules {rootPath = areas + "/augments";};
  mkHostModules = host: gate.importModules {rootPath = ./${host};};
  mkUserModules = user: gate.importModules {rootPath = areas + "/home/${user}";};

  # Reusable module bundles
  desktopModules = baseAugments ++ [];

  diskoNvme = [
    inputs.disko.nixosModules.disko
    {disko.devices.disk.main.device = "/dev/nvme0n1";}
  ];
in {
  nixosConfigurations = {
    skald = gate.nixos {
      inherit system inputs;
      modules =
        [{networking.hostName = "skald";}]
        ++ (mkHostModules "skald")
        ++ desktopModules;
    };

    snake = gate.nixos {
      inherit system inputs;
      modules =
        [{networking.hostName = "snake";}]
        ++ (mkHostModules "snake")
        ++ diskoNvme;
    };
  };

  homeConfigurations = {
    "john@skald" = gate.homeManager {
      inherit system inputs;
      modules =
        mkUserModules "john";
    };
  };
}
