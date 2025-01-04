{
  pkgs,
  self',
  inputs',
  ...
}: let
in {
  home.packages = [
    inputs'.search-flake-inputs.packages.default
  ];
}
