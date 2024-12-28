{pkgs, ...}: {
  programs.thefuck = {
    enable = true;
    package = pkgs.thefuck.overridePythonAttrs {doCheck = false;};
  };
}
