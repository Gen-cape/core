{
  pkgs,
  inputs',
  ...
}: {
  home.packages = with pkgs; [
    inputs'.nixpkgs-stable.legacyPackages.tela-icon-theme
    inputs'.nixpkgs-stable.legacyPackages.libsForQt5.qtstyleplugin-kvantum
    inputs'.nixpkgs-stable.legacyPackages.kdePackages.qt6ct
    inputs'.nixpkgs-stable.legacyPackages.sweet
    inputs'.nixpkgs-stable.legacyPackages.sweet-nova
    inputs'.nixpkgs-stable.legacyPackages.sweet-folders
  ];

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Sweet-Dark
    '';

    "Kvantum/Sweet-Dark".source = "${pkgs.sweet}/share/Kvantum/Sweet-Dark";
  };
}
