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
        allowUnfreePredicate = _: true;
        allowUnsupportedSystem = true;
      };
    };
    _module.args.pkgs = config.legacyPackages;
  };
}
