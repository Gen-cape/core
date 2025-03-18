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
          # rust-lang.rust-analyzer
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
    };
  };
}
