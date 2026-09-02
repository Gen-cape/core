{...}: {
  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    connect-timeout = 5;
    fallback = true;
    http-connections = 50;
    max-substitution-jobs = 128;
  };
}
