{
  self,
  lib,
  inputs,
  ...
}: let
  getModulesFzf = inputs.riptide.mimics.getModulesFzf;
  inherit (lib.lists) concatLists;
  mod = requests: dropExpr:
    getModulesFzf {
      path = ./.;
      inherit requests;
      inherit dropExpr;
    };
in {
  imports = concatLists [
    (mod [".nix"] ["default.nix" "module.nix" "__" "ntpd" "npins"])

    [
    ]
  ];
}
