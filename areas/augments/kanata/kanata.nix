{
  pkgs,
  lib,
  ...
}: let
in {
  environment.systemPackages = [
    (pkgs.kanata.overrideAttrs (oldAttrs: rec {
      pname = "kanata";
      version = "1.8.0-prerelease-1";
      src = pkgs.fetchFromGitHub {
        owner = "jtroo";
        repo = pname;
        rev = "dbd31e061b1971d3d014fc28a622f514c2e652d4";
        sha256 = "sha256-Hnsep3vawp7RKUv+hrACrfOOqftMAtKTesDO76NBMNQ=";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-VEHRGbjLz1pWcnx5fknS4fohB4mt3+trUNzoWyw2TPE=";
      });
    }))
  ];

  services.kanata = {
    enable = false;
    keyboards.laptop = {
      devices = [];
      config =
        builtins.readFile ./kanata.kbd
        + (import ./__kanata-test.nix {inherit lib;});
      #+ builtins.readFile ./kanata-seq-obsidian.kbd;
    };
  };

  boot.kernelModules = ["uinput"];
}
