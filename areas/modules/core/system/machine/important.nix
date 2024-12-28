{
pkgs,
lib,
...
}: {
  # NEVER toggle off until I get a framework laptop *sob*
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
