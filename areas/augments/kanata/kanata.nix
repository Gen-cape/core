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
        rev = "da4e7c251276437d5276109c3b2619f9cb8bb57a";
        sha256 = "sha256-pm3KuBMit0770d+ws1TnJu63+1k2tQab9frlQ+sybh0=";
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
