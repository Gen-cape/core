{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkMerge mkIf;
  inherit (lib.types) enum;

  cfg = config.core.cpu;
in {
  options.core.cpu = {
    type = mkOption {
      type = enum ["amd"];
      description = "The type of CPU the host system uses.";
    };
  };

  config = mkMerge [
    (mkIf (cfg.type == "amd") {
      hardware.cpu.amd = {updateMicrocode = true;};
    })
  ];
}
