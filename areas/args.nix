{inputs, ...}: {
  perSystem = {
    config,
    system,
    ...
  }: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };
    _module.args.pkgs = config.legacyPackages;
  };
}
