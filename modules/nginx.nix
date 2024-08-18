{
  # configure nginx
  services.nginx = {
    enable = true;
    forceSSL = true;
    enableACME = true;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
