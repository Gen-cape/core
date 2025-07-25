{
  services.zapret = {
    enable = true;
    params = [
      "--dpi-desync=fakedsplit"
      "--dpi-desync-ttl=8"
      "--dpi-desync-split-pos=method+2" # needs update
    ];
  };
}
