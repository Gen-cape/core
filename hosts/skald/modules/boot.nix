{pkgs, ...}: let
  sidoniaTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "sidonia-grub-theme-t4-1080p";
    version = "1.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "Aleph1-9012";
      repo = "Sidonia";
      rev = "ecc568e5dc45996e287ff19bf245569744e7e941";
      hash = "sha256-9gnLWD0cT/rz5oGbsnBi9ky5NG2ELkFgV5Lrr0gCXnA=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r themes/T4/1080p/. "$out/"
      runHook postInstall
    '';
  };
in {
  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";

      gfxmodeEfi = "1920x1080";
      theme = sidoniaTheme;
      font = "${sidoniaTheme}/fonts/sidonia-t4-1080p.pf2";
    };

    initrd.verbose = false;
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    supportedFilesystems = ["ntfs"];
    tmp.cleanOnBoot = true;
  };
}
