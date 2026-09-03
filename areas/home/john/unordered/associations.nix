{...}: {
  xdg = {
    enable = true;

    # Prevents the double .config/ nesting bug
    configFile."mimeapps.list".target = "mimeapps.list";

    mimeApps = {
      enable = true;

      defaultApplications = {
        # Web Browsing
        "text/html" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/about" = "zen-beta.desktop";
        "x-scheme-handler/unknown" = "zen-beta.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";

        # Text & Terminal
        "text/plain" = "nvim.desktop";
        "x-scheme-handler/terminal" = "Alacritty.desktop";

        # Chat & Media Streaming
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
        "x-scheme-handler/spotify" = "spotify.desktop";

        # File Management & Documents
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/pdf" = ["org.pwmt.zathura.desktop" "zen-beta.desktop"];
        "application/doc" = "onlyoffice-desktopeditors.desktop";
        "application/docx" = "onlyoffice-desktopeditors.desktop";
        "application/msword" = "onlyoffice-desktopeditors.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice-desktopeditors.desktop";

        # Images
        "image/png" = "imv.desktop";
        "image/jpg" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/svg+xml" = "imv.desktop";

        # Video
        "video/mp4" = "mpv.desktop";
        "video/mkv" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/avi" = "mpv.desktop";

        # Audio
        "audio/aac" = "org.gnome.Decibels.desktop";
        "audio/mpeg" = "org.gnome.Decibels.desktop";
        "audio/ogg" = "org.gnome.Decibels.desktop";
        "audio/wav" = "org.gnome.Decibels.desktop";
        "audio/flac" = "org.gnome.Decibels.desktop";
        "audio/m4a" = "org.gnome.Decibels.desktop";
        "audio/opus" = "org.gnome.Decibels.desktop";
        "audio/mp3" = "org.gnome.Decibels.desktop";
        "audio/webm" = "org.gnome.Decibels.desktop";
      };
    };

    terminal-exec = {
      enable = true;
      settings = {
        default = ["Alacritty.desktop"];
      };
    };
  };
}
