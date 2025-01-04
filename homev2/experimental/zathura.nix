{
  pkgs,
  self',
  ...
}: let
in {
  home.packages = [
    pkgs.zathura
  ];
}
