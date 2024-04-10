{
  services.openssh = {
    enable = true;

    # since this is a VM, use a separate port than the host's
    ports = [2222];
  };
}
