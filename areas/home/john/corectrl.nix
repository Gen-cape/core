_: let
in {
  config = {
    programs.corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
  };
}
