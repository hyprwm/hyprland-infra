{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  services.openssh = {
    enable = true;

    # since this is a VM, use a separate port than the host's
    ports = [2222];

    settings = {
      PasswordAuthentication = mkForce false;
      KexAlgorithms = mkForce ["sntrup761x25519-sha512@openssh.com"];
      KbdInteractiveAuthentication = mkForce false;
    };
  };
}
