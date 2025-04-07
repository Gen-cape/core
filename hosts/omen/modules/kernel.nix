{
  inputs',
  pkgs,
  ...
}: {
  boot = {
    # kernelPackages = inputs'.chaotic.legacyPackages.linuxPackages_cachyos;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
  };
}
