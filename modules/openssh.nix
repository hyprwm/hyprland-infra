{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  services.openssh = {
    enable = true;

    # since this is a VM, use a different port than the host's
    ports = [2222];

    settings = {
      PasswordAuthentication = mkForce false;
      KexAlgorithms = mkForce [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "diffie-hellman-group-exchange-sha256"
        "sntrup761x25519-sha512@openssh.com"
      ];
      KbdInteractiveAuthentication = mkForce false;
    };
  };
}
