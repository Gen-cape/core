{...}: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      MaxAuthTries = 3;
      LoginGraceTime = 15;
      PasswordAuthentication = false;
      PermitEmptyPasswords = "no";
      ChallengeResponseAuthentication = "no";
      KerberosAuthentication = "no";
      GSSAPIAuthentication = "no";
      X11Forwarding = false;
      PermitUserEnvironment = "no";
      AllowAgentForwarding = "no";
      AllowTcpForwarding = "no";
      PermitTunnel = "no";
    };
  };
}
