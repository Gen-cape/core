{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      python3
      python312Packages.ipykernel
    ];
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;
      extensions = with pkgs.vscode-extensions;
        [
          arrterian.nix-env-selector
          bbenoist.nix
          catppuccin.catppuccin-vsc
          christian-kohler.path-intellisense
          dbaeumer.vscode-eslint
          esbenp.prettier-vscode
          formulahendry.code-runner
          golang.go
          ibm.output-colorizer
          kamadorueda.alejandra
          ms-azuretools.vscode-docker
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode-remote.remote-ssh
          ms-vscode.cpptools
          naumovs.color-highlight
          svelte.svelte-vscode
          ms-vsliveshare.vsliveshare
          oderwat.indent-rainbow
          pkief.material-icon-theme
          rust-lang.rust-analyzer
          shardulm94.trailing-spaces
          sumneko.lua
          timonwong.shellcheck
          usernamehw.errorlens
          xaver.clang-format
          yzhang.markdown-all-in-one
          james-yu.latex-workshop
          redhat.vscode-yaml
          ms-azuretools.vscode-docker
          irongeek.vscode-env
          astro-build.astro-vscode
          vscodevim.vim
        ]
        ++ [
          pkgs.vscode-extensions."2gua".rainbow-brackets
        ];
      #++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #  {
      #    name = "copilot-nightly";
      #    publisher = "github";
      #    version = "1.67.7949";
      #    sha256 = "sha256-ZtUqQeWjXmTz49DUeYkuqSTdVHRC8OfgWv8fuhlHDVc=";
      #  }
      #  {
      #    name = "vscode-chromium-vector-icons";
      #    publisher = "adolfdaniel";
      #    version = "1.0.2";
      #    sha256 = "sha256-Meo53e/3jUP6YDEXOA/40xghI77jj4iAQus3/S8RPZI=";
      #  }
      #];
      #userSettings = {
      #  "workbench.iconTheme" = "material-icon-theme";
      #  "workbench.colorTheme" = "Catppuccin Macchiato";
      #  "catppuccin.accentColor" = "mauve";
      #  "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons, 'monospace', monospace";
      #  "editor.fontSize" = 16;
      #  "editor.fontLigatures" = true;
      #  "workbench.fontAliasing" = "antialiased";
      #  "files.trimTrailingWhitespace" = true;
      #  "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
      #  "window.titleBarStyle" = "custom";
      #  "terminal.integrated.automationShell.linux" = "nix-shell";
      #  "terminal.integrated.defaultProfile.linux" = "zsh";
      #  "terminal.integrated.cursorBlinking" = true;
      #  "terminal.integrated.enableBell" = false;
      #  "editor.formatOnPaste" = true;
      #  "editor.formatOnSave" = true;
      #  "editor.formatOnType" = false;
      #  "editor.minimap.enabled" = false;
      #  "editor.minimap.renderCharacters" = false;
      #  "editor.overviewRulerBorder" = false;
      #  "editor.renderLineHighlight" = "all";
      #  "editor.inlineSuggest.enabled" = true;
      #  "editor.smoothScrolling" = true;
      #  "editor.suggestSelection" = "first";
      #  "editor.guides.indentation" = true;
      #  "editor.guides.bracketPairs" = true;
      #  "editor.bracketPairColorization.enabled" = true;
      #  "window.nativeTabs" = true;
      #  "window.restoreWindows" = "all";
      #  "window.menuBarVisibility" = "toggle";
      #  "workbench.panel.defaultLocation" = "right";
      #  "workbench.editor.tabCloseButton" = "left";
      #  "workbench.startupEditor" = "none";
      #  "workbench.list.smoothScrolling" = true;
      #  "security.workspace.trust.enabled" = false;
      #  "explorer.confirmDelete" = false;
      #  "breadcrumbs.enabled" = true;
      #};
    };
  };
}
