{
  pkgs,
  lib,
  ...
}: {
  stylix.targets.vscode.enable = false;
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = [
        pkgs.vscode-extensions.catppuccin.catppuccin-vsc
      ];
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
        "editor.fontFamily" = lib.mkForce "'JetBrainsMono Nerd Font', 'monospace'";
        "editor.fontSize" = lib.mkForce 14;
        "editor.fontLigatures" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "window.titleBarStyle" = "custom";
        "telemetry.telemetryLevel" = "off";
      };
    };
  };
}
