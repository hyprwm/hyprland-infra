{
  # configure nginx
  services.nginx = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
