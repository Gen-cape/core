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
  desktopModules =
    baseAugments
    ++ [
      inputs.nix-gaming.nixosModules.pipewireLowLatency
    ];

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

    omen = gate.nixos {
      inherit system inputs;
      modules =
        [{networking.hostName = "omen";}]
        ++ (mkHostModules "omen")
        ++ desktopModules
        ++ diskoNvme;
    };

    snake = gate.nixos {
      inherit system inputs;
      modules =
        [{networking.hostName = "snake";}]
        ++ (mkHostModules "snake")
        ++ diskoNvme;
    };

    kitsune = gate.nixos {
      inherit system inputs;
      modules =
        [
          {networking.hostName = "kitsune";}
          inputs.disko.nixosModules.disko
        ]
        ++ (mkHostModules "kitsune");
    };
  };

  homeConfigurations = {
    "john@skald" = gate.homeManager {
      inherit system inputs;
      modules =
        mkUserModules "john";
    };

    "john@omen" = gate.homeManager {
      inherit system inputs;
      modules =
        mkUserModules "john";
    };
  };
}
