{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe getExe';
  inherit (pkgs) eza bat ripgrep dust procs yt-dlp python3 netcat-gnu;

  dig = getExe' pkgs.dnsutils "dig";
  nr = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
  templateDir = "~/riptide";
  flakeDir = "~/constructed-core";
in {
  programs.fish.shellAbbrs = {
    # easy netcat alias for my fiche host
    # https://github.com/solusipse/fiche
    fbin = "${getExe netcat-gnu} p.frzn.dev 9999";

    # nix specific aliases
    cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
    bloat = "nix path-info -Sh /run/current-system";
    curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\"";
    repair = "nix-store --verify --check-contents --repair";
    run = "nix run";
    search = "nix search";
    shell = "nix shell";
    repl = "nix repl";
    build = "nix build $@ --builders \"\"";
    dvp = "nix develop";

    bttr = "acpi --battery --details --thermal";
    yz = "yazi";
    unf = "export NIXPKGS_ALLOW_UNFREE=1";
    zl = "zellij";
    zls = "zellij list-sessions";
    zlsc = "zellij delete-all-sessions";

    vtm = "nvim /tmp/temp.temp";
    tup = "sudo tailscale up";
    tdo = "sudo tailscale down";
    sup = "sudo tailscale up";
    sdo = "sudo tailscale down";

    frepl = ", ghci";
    hrepl = ", ghci";
    hcalc = ", ghci";
    fcalc = ", ghci";

    tmm = "mkdir -p tmsuMount && tmsu mount tmsuMount";
    tmu = "tmsu unmount tmsuMount";
    tt = "tmsu tag";
    tmuu = "sudo umount -f -l ./tmsuMount";
    cpl = "cp -LR";

    nvfr = "nix run ~/neovim#default --no-substitute";

    nvr = "~/neovim/nvim/bin/nvim";

    melt = "nix-melt";
    sflake = "search-flake-inputs.nu -f . -i";

    flrc = "echo \"use flake\" > .envrc";
    pyFlake = "nix flake init -t ${templateDir}#pip && echo \"use flake\" > .envrc && direnv allow ";
    rFlake = "nix flake init -t ${templateDir}# && echo \"use flake\" > .envrc && direnv allow ";
    rfl = "nix flake init -t ${templateDir}# && echo \"use flake\" > .envrc && direnv allow ";

    breb = "nh os boot && nh home switch && reboot";

    # JJ aliases

    lg = "jj log --no-pager";
    log = "jj log --no-pager";
    st = "jj st --no-pager";
    ab = "jj abandon @";
    nw = "jj new";
    new = "jj new ";
    ed = "jj edit";
    nb = "jj new -B @ -m";
    sqi = "jj squash -i";
    sq = "jj squash";
    und = "jj undo";
    ds = "jj describe @ -m";
    dsc = "jj describe";
    jdiff = "jj diff";
    jd = "jj diff --from @- --to @";
    jdi = "jj diff --from ";
    patchForm = "jj diff --git --from";
    jgit = "jj git clone";
    jgi = "jj git clone --colocate";
    jlog = "jj log -r ::";
    jl = "jj log -r :: --no-pager --limit 5";
    jll = "jj log -r :: --no-pager --limit 10";
    jlll = "jj log -r :: --no-pager --limit 20";
    jllll = "jj log -r :: --no-pager";
    jim = "jj log -r \"@ | root() | bookmarks()\" --no-pager";
    jin = "jj git init --colocate";
    book = "jj bookmark move main";
    jf = "jj-fzf";
    jfzf = "jj-fzf";
    jfz = "jj-fzf";

    jjk = "jj new -m \"FEAK PICTION, ABSOULTE CINEMA\"";

    gitfe = "git fetch origin pull/id/head:NAME";
    gitf = "git fetch origin pull//head:";
    gits = "git switch";

    lj = "lazyjj";

    ag = "eval (ssh-agent -c)";
    agd = "ssh-add";
    agadd = "ssh-add ~/.ssh/";

    # quality of life aliases
    cat = "${getExe bat} --style=plain";
    grep = "${getExe ripgrep}";
    du = "${getExe dust}";
    ps = "${getExe procs}";
    mp = "mkdir -p";
    fcd = "cd $(find -type d | fzf)";
    ls = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
    l = "ls -lF --time-style=long-iso --icons";
    ytmp3 = ''
      ${getExe yt-dlp} -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
    '';

    # system aliases
    sc = "sudo systemctl";
    jc = "sudo journalctl";
    scu = "systemctl --user ";
    jcu = "journalctl --user";
    errors = "journalctl -p err..alert";
    la = "${getExe eza} -lah --tree";
    tree = "${getExe eza} --tree --icons=always";
    http = "${getExe python3} -m http.server";
    burn = "pkill -9";
    diff = "diff --color=auto";
    cpu = ''watch -n.1 "grep \"^[c]pu MHz\" /proc/cpuinfo"'';
    killall = "pkill";
    switch-yubikey = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
    skill = "pkill -SIGUSR1";
    nau = "nautilus .";

    kwb = "pkill -SIGUSR1 .waybar-wrapped";
    swb = "systemctl --user restart waybar";

    # insteaed of querying some weird and random"what is my ip" service
    # we get our public ip by querying opendns directly.
    # <https://unix.stackexchange.com/a/81699>
    canihazip = "${dig} @resolver4.opendns.com myip.opendns.com +short";
    canihazip4 = "${dig} @resolver4.opendns.com myip.opendns.com +short -4";
    canihazip6 = "${dig} @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6";

    # faster navigation
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";

    #rebuild = "nix-store --verify; pushd ~dotfiles ; ${nr} switch --flake .#$1 --use-remote-sudo && notify-send \"Done\" ; popd";
    #deploy = "${nr} switch --flake .#$1 --target-host $1 --use-remote-sudo -Lv";

    # things I do to keep my home directory clean
    #wget = "wget --hsts-file='\${XDG_DATA_HOME}/wget-hsts'";
    #"gpl" = "${lib.getExe pkgs.curl} https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
    rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
    upd = "nix flake update ${flakeDir}";
    upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";

    hms = "home-manager switch --flake ${flakeDir}";

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

    v = "nvim";
    # se = "sudoedit";
    # ff = "fastfetch";

    #rgf = "rg --files | rg";

    try = "nix-shell -p";
    tr = "nix shell nixpkgs#";

    insp = "nix-inspect -p ./";

    # gadd = "git add .";
    # gacp = ''
    #   gacp() {
    #     git add . && \
    #       git commit -m "anonimous commit" && \
    #       git push
    #   }
    # '';
    # # tmux is picky with teminal colors
    #tmux = "TERM=tmux-256color tmux -u";
    #tms = "TERM=tmux-256color tms";
  };
}
