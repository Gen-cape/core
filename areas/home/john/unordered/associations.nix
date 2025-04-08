{pkgs, ...}: {
  # System Packages
  # environment.systemPackages = with pkgs; [];

  home.sessionVariables = {
    # EDITOR = "/home/john/neovim/nvim/bin/nvim +star";
    EDITOR = "nvim";
  };
  # MIME Associations
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    # Browser handlers
    # "text/html" = "zen.desktop";
    # "x-scheme-handler/http" = "zen.desktop";
    # "x-scheme-handler/https" = "zen.desktop";
    # "x-scheme-handler/about" = "zen.desktop";
    # "x-scheme-handler/unknown" = "zen.desktop";
    "x-scheme-handler/http" = "zen_twilight.desktop";
    "x-scheme-handler/https" = "zen_twilight.desktop";
    "x-scheme-handler/about" = "zen_twilight.desktop";
    "x-scheme-handler/unknown" = "zen_twilight.desktop";
    "application/pdf" = ["org.pwmt.zathura.desktop" "zen_twilight.desktop"];

    "x-scheme-handler/about       " = "zen_twilight.desktop";
    "x-scheme-handler/http        " = "zen-twilight.desktop";
    "x-scheme-handler/https       " = "zen-twilight.desktop";
    "x-scheme-handler/tg          " = "org.telegram.desktop.desktop";
    "x-scheme-handler/tonsite     " = "org.telegram.desktop.desktop";
    "x-scheme-handler/unknown     " = "zen_twilight.desktop ";
    "x-scheme-handler/chrome      " = "zen-twilight.desktop ";
    "text/html                    " = "zen-twilight.desktop ";
    "application/x-extension-htm  " = "zen-twilight.desktop ";
    "application/x-extension-html " = "zen-twilight.desktop ";
    "application/x-extension-shtml" = "zen-twilight.desktop ";
    "application/xhtml+xml        " = "zen-twilight.desktop ";
    "application/x-extension-xhtml" = "zen-twilight.desktop ";
    "application/x-extension-xht  " = "zen-twilight.desktop ";

    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
    "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    # File manager
    "inode/directory" = "org.gnome.Nautilus.desktop";

    # Documents
    # "application/pdf" = ["org.pwmt.zathura.desktop" "firefox.desktop"];
    "application/doc" = "libreoffice-writer.desktop";
    "application/docx" = "libreoffice-writer.desktop";
    "application/msword" = "libreoffice-writer.desktop";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice-writer.desktop";
    "application/vnd.oasis.opendocument.text" = "libreoffice-writer.desktop";
    "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
    "application/vnd.oasis.opendocument.presentation" = "libreoffice-impress.desktop";

    # Images
    "image/png" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop" "org.gnome.Nautilus.desktop"];
    "image/jpg" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop" "org.gnome.Nautilus.desktop"];
    "image/jpeg" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop" "org.gnome.Nautilus.desktop"];
    "image/webp" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop" "org.gnome.Nautilus.desktop"];
    "image/gif" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop" "org.gnome.Nautilus.desktop"];
    "image/bmp" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop" "org.gnome.Nautilus.desktop"];
    "image/tiff" = ["org.nomacs.ImageLounge.desktop" "org.kde.krita.desktop" "org.gnome.Nautilus.desktop"];

    # Video
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/avi" = "mpv.desktop";
    "video/msvideo" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
    "video/x-ms-wmv" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";

    # Audio
    "audio/aac" = "mpv.desktop";
    "audio/mpeg" = "mpv.desktop";
    "audio/ogg" = "mpv.desktop";
    "audio/wav" = "mpv.desktop";
    "audio/webm" = "mpv.desktop";
    "audio/flac" = "mpv.desktop";
    "audio/mp4" = "mpv.desktop";
    "audio/x-m4a" = "mpv.desktop";
    "audio/opus" = "mpv.desktop";
  };
}
