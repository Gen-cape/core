{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    umu-launcher
  ];

  xdg.mime.defaultApplications = {
    "application/x-ms-dos-executable" = "umu-run.desktop";
    "application/x-msi" = "umu-run.desktop";
    "application/x-ms-shortcut" = "umu-run.desktop";
  };

  environment.etc."xdg/applications/umu-run.desktop".text = ''
    [Desktop Entry]
    Name=UMU-Run
    Comment=Run Windows programs with UMU-Run
    Exec=umu-run %f
    Terminal=false
    Type=Application
    Categories=Application;Utility;
    NoDisplay=false
    MimeType=application/x-ms-dos-executable;application/x-msi;application/x-ms-shortcut;
  '';
}
