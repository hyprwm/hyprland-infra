{
  # configure nginx
  services.nginx = {
    enable = true;
    forceSSL = true;
    enableACME = true;
  };
}
