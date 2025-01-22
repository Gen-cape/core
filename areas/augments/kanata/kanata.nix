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
        rev = "81f2faf745865cd58eab322d33114b5bca2a3a01";
        sha256 = "sha256-i513FDCyFrqTD3k+sNl9jBt/iVhE5L+i24UP0iXBOio=";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-6/R1oI4X/uortOgHxernF6OG241UjZWnm0Weqy8lxW4=";
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
