{
  pkgs,
  lib,
  ...
}: let
in {
  environment.systemPackages = [
    # (pkgs.kanata.overrideAttrs (oldAttrs: rec {
    #   pname = "kanata";
    #   version = "1.8.1";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "jtroo";
    #     repo = pname;
    #     rev = "v${version}";
    #     sha256 = "sha256-w/PeSqj51gJOWmAV5UPMprntdzinX/IL49D2ZUMfeSM=";
    #   };
    #   cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    #     inherit src;
    #     hash = "sha256-T9fZxv3aujYparzVphfYBJ+5ti/T1VkeCeCqWPyllY8";
    #   };
    # }))
    pkgs.kanata
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
