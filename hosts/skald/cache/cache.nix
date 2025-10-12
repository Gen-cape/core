{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://cache.garnix.io"
      "https://nyx.chaotic.cx"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://yazi.cachix.org"
    ];

    trusted-public-keys = [];
  };
}
