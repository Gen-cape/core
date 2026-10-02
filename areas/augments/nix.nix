{
  pkgs,
  config,
  ...
}: {
  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    nixos.enable = false;
  };
  programs.command-not-found.enable = false;
  programs.nh = {
    enable = true;
    flake = "/home/john/core";
    clean = {
      enable = true;
      extraArgs = "--keep 5";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.lix;

    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "best-effort";
    daemonIOSchedPriority = 7;

    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
      connect-timeout = 5;
      stalled-download-timeout = 20;
      min-free = toString (5 * 1024 * 1024 * 1024); # 5 GiB
      max-free = toString (10 * 1024 * 1024 * 1024); # 10 GiB
    };

    optimise = {
      automatic = true;
      dates = ["04:00"];
    };
  };
}
