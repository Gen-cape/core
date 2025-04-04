{inputs', ...}: {
  boot = {
    kernelPackages = inputs'.chaotic.legacyPackages.linuxPackages_cachyos;
  };
}
