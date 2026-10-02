# flake.nix --- the wires that hold all of this;
#
# Welcome to the ground zero.
{
  description = "The heart of my system";

  outputs = {self, ...} @ inputs: import ./outputs.nix {inherit inputs self;};

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gate = {
      url = "github:Gen-cape/gate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
