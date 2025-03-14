{
  pkgs,
  lib,
  ...
}: let
in {
  environment.systemPackages = [
    (pkgs.kanata.overrideAttrs (oldAttrs: rec {
      pname = "kanata";
      version = "1.8.0-next";
      src = pkgs.fetchFromGitHub {
        owner = "jtroo";
        repo = pname;
        rev = "a9dabfcb07e22c9efa0bc15349780b10afacb6cd";
        sha256 = "sha256-ELdjTNcM5AEY/wLBPkWmY/s05F2b+POBOlX8PvKphVE=";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-cfWJigApFDB3U7sE904mb0CbunkGIIHXBbaI/bAf2tI=";
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
