{pkgs, ...}: let
  hijacker2 = pkgs.rustPlatform.buildRustPackage {
    pname = "hijacker2";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "chilipizdrick";
      repo = "hijacker2";
      rev = "master";
      hash = "sha256-fk+Nt5Mq7sDJAfmkScMwpavVWsEVqC5mhDYsG1bp1F4=";
    };

    cargoHash = "sha256-mJb/Vf1ayF1I0NRWUracjy4/bkqvlAWEjufyW0Fr3Xg";

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.rustPlatform.bindgenHook
    ];

    buildInputs = [
      pkgs.pipewire
    ];
  };

  clever-hijacker = pkgs.writeShellScriptBin "clever-hijacker" ''
    set -e

    if ${pkgs.pipewire}/bin/pw-dump | ${pkgs.gnugrep}/bin/grep -q "$1"; then
      ${hijacker2}/bin/hijacker2 -a "$1" "$2"
    else
      ${hijacker2}/bin/hijacker2 "$2"
    fi
  '';

  hijacker-ctl = pkgs.writeShellScriptBin "hijacker-ctl" ''
    STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/hijacker_enabled"

    case "$1" in
      toggle)
        if [ -f "$STATE_FILE" ]; then
          rm -f "$STATE_FILE"
          noctalia msg notification-show 'Hijacker' 'Disabled'
        else
          touch "$STATE_FILE"
          noctalia msg notification-show 'Hijacker' 'Enabled'
        fi
        ;;
      play)
        if [ -f "$STATE_FILE" ]; then
          ${clever-hijacker}/bin/clever-hijacker 'easyeffects_source' "$HOME/Music/hijacker-presets/$2.mp3"
        fi
        ;;
      *)
        exit 1
        ;;
    esac
  '';
in {
  home.packages = [
    hijacker2
    clever-hijacker
    hijacker-ctl
  ];
}
