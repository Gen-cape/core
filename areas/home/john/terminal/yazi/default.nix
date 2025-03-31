{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.ripdrag
    pkgs.exiftool
    pkgs.zip
    pkgs.p7zip
  ];

  programs.yazi = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableNushellIntegration = config.programs.nushell.enable;

    plugins = {
      filepicker = ./plugins/filepicker;
      compress = ./plugins/compress;
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = ["<C-p>"];
          run = "plugin filepicker";
          desc = "Open filepicker";
        }
        {
          on = ["c" "a"];
          run = "plugin compress";
          desc = "Compress file";
        }
      ];
    };
    settings = {
      manager = {
        layout = [1 4 3];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "${config.xdg.cacheHome}/yazi";
      };
    };
  };
}
