{
  pkgs,
  inputs',
  ...
}: {
  home.packages = with pkgs; [
    # inputs'.riptide.packages.
    pkgs.windsurf
  ];
}
