{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  boot.kernelPackages = pkgs.linuxPackages_hardened;
  security = {
    # Do not allow loading additional kernel modules imperatively.
    lockKernelModules = false;

    # Disallow replacing the running kernel. This breaks hibernation
    # which is practically useless on a server.
    protectKernelImage = true;

    allowSimultaneousMultithreading = mkForce false;
  };
}
