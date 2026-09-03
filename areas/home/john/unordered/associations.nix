{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser handlers
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

      # Chat & Protocols
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

      # File Manager
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # Documents
      "application/pdf" = ["org.pwmt.zathura.desktop" "zen-beta.desktop"];
      "application/doc" = "onlyoffice-desktopeditors.desktop";
      "application/docx" = "onlyoffice-desktopeditors.desktop";
      "application/msword" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice-desktopeditors.desktop";

      # Images
      "image/png" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop"];
      "image/jpeg" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop"];
      "image/jpg" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop"];
      "image/webp" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop"];
      "image/gif" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop"];
      "image/bmp" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop"];
      "image/tiff" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop"];

      # Media
      "video/*" = "mpv.desktop";
      "audio/*" = "mpv.desktop";
    };
  };
}
