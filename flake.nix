# flake.nix --- the wires that hold all of this;
#
# Welcome to the ground zero.
{
  description = "The heart of my system";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        # ./homes
        ./hosts
        ./areas
      ];
      systems = [
        "x86_64-linux"
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
    neovim-riptide.url = "path:/home/john/neovim";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
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

    xdg-desktop-portal-hyprland = {
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

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcursor = {
      url = "github:hyprwm/hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
  };
}
