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
        rev = "0b25d28fd2e06d82e9e2060f88d57cd3f005c981";
        sha256 = "sha256-JI+pXRAP8vES3dFLHEbwVd537AmY0cgd8YWE5nN1vJ4=";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-Iuude62QYVL13NcvQsTznCsRkWF64keWtiKd62otK64=";
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
