{
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

  args = {inherit inputs self;};

  modules = [
    ./hosts
  ];
in
  lib.foldr
  (mod: acc: lib.recursiveUpdate (import mod args) acc)
  {}
  modules
