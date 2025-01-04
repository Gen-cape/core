{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    clock24 = true;
    keyMode = "vi";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    terminal = "tmux-256color";

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.catppuccin
      # tmuxPlugins.rose-pine
    ];

    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # set -g @catppuccin_flavor 'mocha'
      set -g @rose_pine_variant 'main'
    '';
  };

  home.packages = with pkgs; [tmux-sessionizer];
  home.file.".config/tms/config.toml".text =
    /*
    toml
    */
    ''
      [[search_dirs]]
      path = "/home/constructed-core/"
      depth = 2

    '';
}
