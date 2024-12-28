{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [
    pkgs.linuxKernel.packages.linux_zen.amneziawg
    pkgs.amneziawg-tools
    pkgs.amneziawg-go
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [amneziawg];
}
