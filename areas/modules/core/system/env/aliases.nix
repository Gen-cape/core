{
  pkgs,
  lib,
  ...
}: {
  environment.shellAliases = let
    nr = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
    flakeDir = "~/constructed-core";
  in {
    # nix aliases
    rebuild = "nix-store --verify; pushd ~dotfiles ; ${nr} switch --flake .#$1 --use-remote-sudo && notify-send \"Done\" ; popd";
    deploy = "${nr} switch --flake .#$1 --target-host $1 --use-remote-sudo -Lv";

    # things I do to keep my home directory clean
    wget = "wget --hsts-file='\${XDG_DATA_HOME}/wget-hsts'";
    "gpl" = "${lib.getExe pkgs.curl} https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
    #rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
    #upd = "nix flake update ${flakeDir}";
    #upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";

    #hms = "home-manager switch --flake ${flakeDir}";

    # conf = "nvim ${flakeDir}/nixos/configuration.nix";
    # pkgs = "nvim ${flakeDir}/nixos/packages.nix";
    # aliases = "nvim ${flakeDir}/modules/home-manager/aliases/default.nix";
    # eal = "nvim ${flakeDir}/modules/home-manager/aliases/default.nix";

    # la = "eza -a --icons";
    # ll = "eza -l --icons";
    # ls = "eza";
    # l = "eza";

    # n = "neofetch";
    # nf = ''nvim (FZF_DEFAULT_COMMAND='fd' FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'" fzf --height 60% --layout reverse --info inline --border --color 'border:#b48ead')'';
    # r = "yy";
    # top = "btop";

    # x = "z";
    # cd = "z";

    # v = "nvim";
    # se = "sudoedit";
    # ff = "fastfetch";

    #rgf = "rg --files | rg";

    # try="nix-shell -p";
    # tr="nix-shell -p";

    # insp="nix-inspect -p ./";

    # gadd = "git add .";
    # gacp = ''
    #   gacp() {
    #     git add . && \
    #       git commit -m "anonimous commit" && \
    #       git push
    #   }
    # '';
    # # tmux is picky with teminal colors
    # tmux = "TERM=tmux-256color tmux -u";
    # tms = "TERM=tmux-256color tms";
  };
}
