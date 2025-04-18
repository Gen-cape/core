{pkgs, ...}: let
  obsidianWrapper = pkgs.writeShellScriptBin "obsidian" ''
    #!/bin/sh
    exec ${pkgs.obsidian}/bin/obsidian --no-sandbox --ozone-platform=x11 "$@"
  '';

  obsidianDesktop = pkgs.writeTextFile {
    name = "obsidian-desktop";
    destination = "/share/applications/obsidian.desktop";
    text = ''
      [Desktop Entry]
      Name=Obsidian
      Exec=obsidian %U
      Terminal=false
      Type=Application
      Icon=obsidian
      StartupWMClass=obsidian
      Comment=Obsidian
      MimeType=x-scheme-handler/obsidian;
      Categories=Office;
    '';
  };
  obsidianFixed = pkgs.symlinkJoin {
    name = "Obsidian";
    paths = with pkgs; [
      obsidianWrapper
      obsidianDesktop
      obsidian
      pandoc
    ];
  };
in {
  environment.systemPackages = [obsidianFixed];
}
