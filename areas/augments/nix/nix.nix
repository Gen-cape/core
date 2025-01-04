{pkgs, ...}: let
  GiB = 1024 * 1024 * 1024;
in {
  nix = {
    package = pkgs.lix;

    # low priority
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    gc = {
      automatic = true;
      dates = "Sat *-*-* 03:00";
      options = "--delete-older-than 30d";
      persistent = false; # don't try to catch up on missed GC runs
    };
    optimise = {
      automatic = true;
      dates = ["04:00"];
    };

    settings = {
      min-free = "${toString (5 * GiB)}";
      max-free = "${toString (10 * GiB)}";
      auto-optimise-store = true; # Automatically optimise symlinks
      max-jobs = "auto";
      sandbox = true;
      sandbox-fallback = false;

      allowed-users = ["root" "@wheel" "nix-builder"];
      trusted-users = ["root" "@wheel" "nix-builder"];

      connect-timeout = 5;
      stalled-download-timeout = 20;

      log-lines = 30;

      system-features = ["nixos-test" "kvm" "recursive-nix" "big-parallel"];
      extra-experimental-features = [
        "flakes" # flakes
        "nix-command" # experimental nix commands
        "recursive-nix" # let nix invoke itself
        "ca-derivations" # content addressed nix
        "auto-allocate-uids" # allow nix to automatically pick UIDs, rather than creating nixbld* user accounts
        "cgroups" # allow nix to execute builds inside cgroups
        "repl-flake" # allow passing installables to nix repl
        "no-url-literals" # disallow deprecated url-literals, i.e., URLs without quotation
        "dynamic-derivations" # allow "text hashing" derivation outputs, so we can build .drv files.
      ];

      accept-flake-config = false;

      builders-use-substitutes = true;
      keep-going = true;
    };
  };
  systemd.services.nix-gc = {unitConfig.ConditionACPower = true;};
}
