{pkgs, ...}: {
  stylix.iconTheme = {
    enable = true;
    package = pkgs.sweet-folders;
    dark = "Sweet-Purple"; # Using the filled purple variant
    light = "Sweet-Purple"; # Using the regular purple variant for light mode
  };

  home.packages = with pkgs; [
    sweet
    sweet-nova
    sweet-folders
  ];
}
