{
  pkgs,
  inputs',
  ...
}: {
  environment.systemPackages = with pkgs; [
    heroic
    npins
    gpu-screen-recorder
    gpu-screen-recorder-gtk
  ];
  programs.gpu-screen-recorder.enable = true;
}
