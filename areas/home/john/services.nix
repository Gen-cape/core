{
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  programs.fzf.enable = true;
}
