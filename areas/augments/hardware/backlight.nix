{
  config,
  pkgs,
  ...
}: let
in {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
    ];

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
      ];
    };

    hardware.acpilight.enable = true;

    services = {
      acpid = {
        enable = true;
        logEvents = true;
      };
    };
  };
}
