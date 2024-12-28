{self, ...}: {
  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      permittedInsecurePackages = [];

      allowAliases = true;
      enableParallelBuildingByDefault = false; # I trust on this one

      showDerivationWarnings = []; # One day I should tinker this line
    };
  };
  system = {
    # autoUpgrade = false;
    #configurationRevision = self.shortRev or self.dirtyShortRev;
  };
  environment.etc."core-backup".source = self;
}
