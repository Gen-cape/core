{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    keyMode = "vi";
    terminal = "xterm-256color"; # Changed to xterm-256color for better compatibility
    customPaneNavigationAndResize = true;
    newSession = true;
    prefix = "C-a";
    mouse = true;
    extraConfig = ''
      # Fix for proper color support
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ",xterm-256color:RGB"

      set -g detach-on-destroy off     # don't exit from tmux when closing a session
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-position top       # macOS / darwin style

      # Border colors
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      # Disable RGB color if colors look wrong
      set -as terminal-features ",*:RGB"

      # Key bindings
      bind H previous-window
      bind L next-window
      bind r command-prompt "rename-window %%"
      bind R source-file ~/.config/tmux/tmux.conf
      bind ^A last-window
      bind ^W list-windows
      bind w list-windows
      bind z resize-pane -Z
      bind | split-window
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind '"' choose-window
      bind -r -T prefix , resize-pane -L 20
      bind -r -T prefix . resize-pane -R 20
      bind -r -T prefix - resize-pane -D 7
      bind -r -T prefix = resize-pane -U 7
      bind * setw synchronize-panes
      bind P set pane-border-status
      bind C new-window -c "#{pane_current_path}"
      bind c kill-pane
      bind x swap-pane -D
      bind S choose-session
      bind K send-keys "clear"\; send-keys "Enter"
    '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          # Explicitly set theme to avoid color issues
          set -g @catppuccin_flavour 'mocha'

          # Force status style for consistent colors
          set -g status-style "bg=#1e1e2e,fg=#cdd6f4"

          # Window formatting
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"

          # Status bar modules and formatting
          set -g @catppuccin_status_modules_right "directory date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_date_time_text "%H:%M"
        '';
      }
    ];
  };
}
