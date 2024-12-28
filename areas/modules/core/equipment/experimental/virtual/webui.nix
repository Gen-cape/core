{...}: let
  user = "john";
in {
  #   system.activationScripts = {
  #     script.text = ''
  #       install -d -m 755 /home/${user}/open-webui/data -o root -g root
  #     '';
  #   };
  #   virtualisation = {
  #     podman = {
  #       enable = true;
  #       dockerCompat = true;
  #       #defaultNetwork.settings.dns_enabled = true;
  #     };
  #
  #     oci-containers = {
  #       backend = "podman";
  #
  #       containers = {
  #         open-webui = {
  #           image = "ghcr.io/open-webui/open-webui:main";
  #
  #           environment = {
  #             "TZ" = "Europe/Amsterdam";
  #             "OLLAMA_API_BASE_URL" = "http://127.0.0.1:11434/api";
  #             "OLLAMA_BASE_URL" = "http://127.0.0.1:11434";
  #           };
  #
  #           volumes = [
  #             "/home/${user}/open-webui/data:/app/backend/data"
  #           ];
  #
  #           # ports = [
  #           # "127.0.0.1:3000:8080" # Ensures we listen only on localhost
  #           # ["127.0.0.1:<hostPort>:8080"]
  #           # ];
  #
  #           extraOptions = [
  #             "--pull=newer" # Pull if the image on the registry is newer
  #             "--name=open-webui"
  #             "--hostname=open-webui"
  #             # "--network=host"
  #             "--add-host=host.containers.internal:host-gateway"
  #           ];
  #         };
  #       };
  #     };
  #   };
}
