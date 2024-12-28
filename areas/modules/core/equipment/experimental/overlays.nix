{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (lib.trivial) const;
in {
  # nixpkgs.overlays =  (singleton (const (prev: {
  # })));
  nixpkgs.overlays = [
  ];
}
