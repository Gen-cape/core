{inputs, ...}: {
  perSystem = {
    config,
    system,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell rec {
      nativeBuildInputs = [
        (pkgs.writeShellScriptBin "link" ''(cd ~/core/areas/external && bombadil install && bombadil link -p bundle)'')
        (pkgs.writeShellScriptBin "nlink" ''(cd ~/core/areas/external && bombadil install && bombadil link -p)'')
      ];
      buildInputs = [];
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
    };
  };
}
