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
    pkgs.trash-cli
    pkgs.fzf
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableNushellIntegration = config.programs.nushell.enable;

    plugins = {
      filepicker = ./plugins/filepicker;
      compress = ./plugins/compress;
      bunny = ./plugins/bunny;
      diff = ./plugins/diff;
      chmod = ./plugins/chmod;
      bypass = ./plugins/bypass;
      restore = ./plugins/restore;
      fast-enter = ./plugins/fast-enter;
    };

    # Configuration for plugins that require setup
    initLua = ''
      require("bunny"):setup({
        hops = {
          { key = "r",          path = "/",                                    },
          { key = "v",          path = "/var",                                 },
          { key = "t",          path = "/tmp",                                 },
          { key = { "h", "h" }, path = "~",              desc = "Home"         },
          { key = { "h", "d" }, path = "~/Documents",    desc = "Documents"    },
          { key = { "h", "k" }, path = "~/Desktop",      desc = "Desktop"      },
          { key = "c",          path = "~/.config",      desc = "Config files" },
          { key = { "l", "s" }, path = "~/.local/share", desc = "Local share"  },
          { key = { "l", "b" }, path = "~/.local/bin",   desc = "Local bin"    },
        },
        desc_strategy = "path",
        notify = false,
        fuzzy_cmd = "fzf",
      })

      require("restore"):setup({
        position = { "center", w = 70, h = 40 },
        show_confirm = true,
        theme = {
          title = "blue",
          header = "green",
          header_warning = "yellow",
          list_item = { odd = "blue", even = "blue" },
        },
      })
    '';

    # Keymaps for all plugins
    keymap = {
      manager.prepend_keymap = [
        # Existing keymaps
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

        # bunny.yazi - bookmarks/hopping
        {
          on = [";"];
          run = "plugin bunny";
          desc = "Start bunny.yazi";
        }

        # diff.yazi - diff files
        {
          on = ["<C-d>"];
          run = "plugin diff";
          desc = "Diff the selected with the hovered file";
        }

        # chmod.yazi - change permissions
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }

        # bypass.yazi - skip single-folder directories
        {
          on = ["L"];
          run = "plugin bypass";
          desc = "Recursively enter child directory, skipping children with only a single subdirectory";
        }
        {
          on = ["H"];
          run = "plugin bypass reverse"; # FIXED: removed --args= syntax
          desc = "Recursively enter parent directory, skipping parents with only a single subdirectory";
        }

        # restore.yazi - restore deleted files
        {
          on = ["o" "u"];
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }

        # fast-enter.yazi - smart directory navigation
        {
          on = ["l"];
          run = "plugin fast-enter";
          desc = "Enter the subfolder faster, or open the file directly";
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
