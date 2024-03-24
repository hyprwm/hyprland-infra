{
  config,
  self,
  ...
}: {
  # age.secrets.typhon-password = {
  #   file = "${self}/secrets/typhon-password.age";
  #   owner = "typhon";
  #   mode = "400";
  # };

  # enable Typhon
  services.typhon = {
    enable = true;

    # path to the argon2id hash of the admin password
    # $ SALT=$(cat /dev/urandom | head -c 16 | base64)
    # $ echo -n password | argon2 "$SALT" -id -e > /etc/secrets/password.txt
    # hashedPasswordFile = config.age.secrets.typhon-password.path;
  };

  services.nginx.virtualHosts."typhon.hyprland.org" = {
    locations."/" = {
      proxyPass = "http://localhost:3000";
      recommendedProxySettings = true;
    };
  };
}
