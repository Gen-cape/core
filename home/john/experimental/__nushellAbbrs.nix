{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe getExe';
  inherit (pkgs) eza bat ripgrep dust procs yt-dlp python3 netcat-gnu;

  flakeDir = "~/constructed-core";
  dig = getExe' pkgs.dnsutils "dig";
in {
  # nix specific aliases
  cleanup = "sudo nix-collect-garbage --delete-older-than 3d and nix-collect-garbage -d";
  bloat = "nix path-info -Sh /run/current-system";
  curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
  gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\"";
  repair = "nix-store --verify --check-contents --repair";
  run = "nix run";
  search = "nix search";
  shell = "nix shell";
  repl = "nix repl";
  dvp = "nix develop";

  bttr = "acpi --battery --details --thermal";
  yz = "yazi";
  # unf = "export NIXPKGS_ALLOW_UNFREE=1";
  unf = "env.NIXPKGS_ALLOW_UNFREE = 1";
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

  nvfr = "nix run ~/neovim#default --no-substitute";

  nvr = "~/neovim/nvim/bin/nvim";
  nvi = "~/neovim/nvim/bin/nvim +star";

  melt = "nix-melt";
  sflake = "search-flake-inputs.nu -f . -i";

  flrc = "echo \"use flake\" > .envrc";

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
  patchForm = "jj diff --git --from";
  jgit = "jj git clone";
  jgi = "jj git clone --colocate";
  jlog = "jj log -r ::";
  jl = "jj log -r :: --no-pager --limit 5";
  jll = "jj log -r :: --no-pager";
  jim = "jj log -r \"@ | root() | bookmarks()\" --no-pager";
  jin = "jj git init --colocate";
  book = "jj bookmark move main";
  jf = "jj-fzf";
  jfzf = "jj-fzf";
  jfz = "jj-fzf";

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
  fcd = "cd (find | fzf)";
  l = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
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
  killall = "pkill";
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

  #rebuild = "nix-store --verify; pushd ~dotfiles ; ${nr} switch --flake .#$1 --use-remote-sudo and notify-send \"Done\" ; popd";
  #deploy = "${nr} switch --flake .#$1 --target-host $1 --use-remote-sudo -Lv";

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

  v = "nvim";
  try = "nix-shell -p";
  tr = "nix shell nixpkgs#";

  insp = "nix-inspect -p ./";
}
