# flake.nix --- the wires that hold all of this;
#
# Welcome to the ground zero.
{
  description = "The heart of my system";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./hosts
        ./areas
      ];
      systems = [
        "x86_64-linux"
        # "aarch64-linux" "aarch64-darwin" "x86_64-darwin"
      ];
    };

  inputs = {
    riptide = {
      url = "path:/home/john/riptide";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";

    systems.url = "github:nix-systems/default";
    nuenv.url = "https://flakehub.com/f/DeterminateSystems/nuenv/*.tar.gz";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    search-flake-inputs = {
      url = "github:shivaraj-bh/search-flake-inputs";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        hyprutils.follows = "hyprland";
        nixpkgs.follows = "nixpkgs-small";
        hyprwayland-scanner.follows = "hyprland";
        systems.follows = "systems";
      };
    };

    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs = {
        hyprlang.follows = "hyprland";
        hyprutils.follows = "hyprland";
        nixpkgs.follows = "nixpkgs-small";
        hyprland-protocols.follows = "hyprland";
        hyprwayland-scanner.follows = "hyprland";
        systems.follows = "systems";
      };
    };
    # hyprpaper = {
    #   url = "github:hyprwm/hyprpaper";
    #   inputs = {
    #     hyprlang.follows = "hyprland";
    #     hyprutils.follows = "hyprland";
    #     nixpkgs.follows = "nixpkgs-small";
    #     hyprwayland-scanner.follows = "hyprland";
    #     systems.follows = "systems";
    #   };
    # };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
      };
    };

    # treemft-nix.url = "github:numtide/treefmt-nix";
    # treemft-nix.inputs.nixpkgs.follows = "nixpkgs-small";
    # nixfmt.url = "github:nixos/nixfmt";
    # nvf.url = "github:NotAShelf/nvf";
    # anyrun.url = "github:anyrun-org/anyrun";
    # anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    # ags.url = "github:Aylur/ags";
    # ags.inputs.nixpkgs.follows = "nixpkgs";
    # schizofox.url = "github:schizofox/schizofox";
    # nil.url = "github:oxalica/nil";
    # nixpak.url = "github:nixpak/nixpak";
    # nh = {
    #   url = "github:viperML/nh";
    #   inputs.nixpkgs.follows = "nixpkgs-small";
    # };
  };
}
