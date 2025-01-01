{
  lib,
  self,
  inputs,
  ...
}: let
  template = import inputs.riptide.mimics.xdgTemplate "nixos";
in {
  environment = {
    variables = template.glEnv;
    sessionVariables = template.sysEnv;
    etc = {inherit (template) pythonrc npmrc;};
  };
}
