{pkgs, ...}: {
  home-manager.users.john = {
    home.packages = with pkgs; [
      tela-icon-theme
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qt6ct
      sweet
      sweet-nova
      sweet-folders
    ];

    xdg.configFile = {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Sweet-Dark
      '';

      "Kvantum/Sweet-Dark".source = "${pkgs.sweet-kde}/share/Kvantum/Sweet-Dark";
    };
  };
}
