{inputs, ...}: {
  perSystem = {
    config,
    system,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell rec {
      nativeBuildInputs = [
        # (pkgs.writeShellScriptBin "link" ''(cd ~/core/areas/external && bombadil install && bombadil link -p bundle)'')
        # (pkgs.writeShellScriptBin "nlink" ''(cd ~/core/areas/external && bombadil install && bombadil link -p)'')

        (pkgs.writeShellScriptBin "linkf" ''
          (cd ~/core/areas/external && dotter -f "$@")
        '')
        (pkgs.writeShellScriptBin "link" ''
          (cd ~/core/areas/external && dotter "$@")
        '')

        (pkgs.writeShellScriptBin "nlink" ''
          (cd ~/core/areas/external && dotter undeploy "$@")
        '')

        (pkgs.writeShellScriptBin "nlinkf" ''
          (cd ~/core/areas/external && dotter undeploy -y "$@")
        '')
        (pkgs.writeShellScriptBin "kl" ''(cd ~/core/areas/ && just "$@")'')
        pkgs.gum
        pkgs.just
        pkgs.nushell
      ];
      buildInputs = [];
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
    };
  };
}
