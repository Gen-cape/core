{
  nix.settings = {
    connect-timeout = 5; # abort connection attempts to caches after 5s
    fallback = true; # build from source if cache server error
  };
}
