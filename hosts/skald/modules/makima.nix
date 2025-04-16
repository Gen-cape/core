{pkgs, ...}: {
  environment.systemPackages = [
    (
      pkgs.makima.overrideAttrs (oldAttrs: rec {
        pname = "makima";
        version = "0.10.1";

        src = pkgs.fetchFromGitHub {
          owner = "cyber-sushi";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-Pb9XBMs0AeklobxEDRQ1GDeI6hQFZ43EJt/+XQEGrWU=";
        };

        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-7XpecFwkUW3VVMYUAmHEL9gk5mpwC0mWN2N8Dptm3iI=";
        };
      })
    )
    pkgs.ydotool
    pkgs.evtest
    pkgs.wtype
    pkgs.antimicrox
    pkgs.evemu
  ];
  programs.ydotool.enable = true;
  services.input-remapper.enable = true;
}
