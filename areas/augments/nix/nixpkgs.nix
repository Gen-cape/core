{self, ...}: {
  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      permittedInsecurePackages = [];
      allowAliases = true;
    };
  };
  environment.etc."core-backup".source = self;
}
