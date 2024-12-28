{
  lib,
  mimics,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) bool str;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (mimics) dropFunctor;

  mkOpt = type: default:
    mkOption {
      inherit type default;
      description = "fast created option with ";
    };
  mkOpt' = type: default: let
    def = mkOption {
      inherit type default;
      description = "fast created option with ";
    };
  in
    {
      __functor = self: arg:
        if arg != {}
        then recursiveUpdate self arg
        else dropFunctor self;
    }
    // def;
  mkStrOpt = default: mkOpt str default;
  mkDisableOpt = name: mkEnableOption name // {default = true;};
in {
  inherit
    mkOpt
    mkOpt'
    mkStrOpt
    mkDisableOpt
    ;
}
