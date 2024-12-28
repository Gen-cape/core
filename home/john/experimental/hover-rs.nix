{
  pkgs,
  self',
  inputs',
  ...
}: let
  hover-rs = pkgs.fetchFromGitHub {
    owner = "viperML";
    repo = "hover-rs";
    rev = "7a699b1e8a52c416e6d113a000b500752a6c3371";
    hash = "sha256-dpwU7X3Xbiyttv/Jr4mnHvCQ0t0ISICpiTrWwQbdgck=";
  };
in {
  #home.packages = [
  #  (pkgs.callPackage "${hover-rs}/package.nix" {})
  #];
}
