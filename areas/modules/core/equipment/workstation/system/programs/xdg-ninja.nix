{
  lib,
  self,
  ...
}: let
  template = import self.qol.xdgTemplate "nixos";
in {
  environment = {
    variables = template.glEnv;
    sessionVariables = template.sysEnv;
    etc = {inherit (template) pythonrc npmrc;};
  };
}
