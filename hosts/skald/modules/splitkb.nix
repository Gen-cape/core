{pkgs, ...}: {
  ### KERNEL ###
  # boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  # boot.kernelModules = [
  #   "i2c-dev"
  #   "ddcci_backlight"
  # ];
  services.udev = {
    extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
    packages = with pkgs; [via vial];
  };
  environment.systemPackages = with pkgs; [
    # ddcci
    vial
    appimage-run
  ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
