{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser handlers
      "text/html" = "zen-twilight.desktop";
      "application/xhtml+xml" = "zen-twilight.desktop";
      "application/x-extension-htm" = "zen-twilight.desktop";
      "application/x-extension-html" = "zen-twilight.desktop";
      "application/x-extension-shtml" = "zen-twilight.desktop";
      "application/x-extension-xhtml" = "zen-twilight.desktop";
      "application/x-extension-xht" = "zen-twilight.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/about" = "zen-twilight.desktop";
      "x-scheme-handler/unknown" = "zen-twilight.desktop";
      "x-scheme-handler/chrome" = "zen-twilight.desktop";

      # Chat & Protocols
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

      # File Manager
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # Documents
      "application/pdf" = ["org.pwmt.zathura.desktop" "zen-twilight.desktop"];
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
