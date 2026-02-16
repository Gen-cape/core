{inputs', ...}: let
  freshest =
    inputs'.fresh.legacyPackages;
in {
  services.ollama = {
    enable = true;
    package = freshest.ollama;
  };
}
