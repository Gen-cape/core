{
  pkgs,
  inputs',
  ...
}: {
  # stylix.iconTheme = {
  #   enable = true;
  #   package = pkgs.sweet;
  #   dark = "Sweet-Purple"; # Using the filled purple variant
  #   light = "Sweet-Purple"; # Using the regular purple variant for light mode
  # };

  home.packages = with pkgs; [
    # sweet
    # inputs'.nixpkgs-stable.legacyPackages.sweet
    # inputs'.nixpkgs-stable.legacyPackages.sweet-nova
    # inputs'.nixpkgs-stable.legacyPackages.sweet-folders
  ];
}
