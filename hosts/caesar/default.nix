{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (lib.meta) getExe;
in {
  imports = [./virt.nix];
  config = {
    zramSwap.enable = mkForce false;
    services.thermald.enable = mkForce false;

    boot = {
      initrd.supportedFilesystems = ["ext4"];

      kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      promptInit = ''
        eval "$(${getExe pkgs.starship} init zsh)"
      '';
    };

    boot.initrd.preLVMCommands = with pkgs; ''
      if ! test -b /dev/vda2; then
        ${pkgs.parted}/bin/parted --script /dev/vda -- mklabel msdos
        ${pkgs.parted}/bin/parted --script /dev/vda -- mkpart primary 1MiB -250MiB
        ${pkgs.parted}/bin/parted --script /dev/vda -- mkpart primary -250MiB 100%
        sync
      fi

      FSTYPE=$(blkid -o value -s TYPE /dev/vda2 || true)
      if test -z "$FSTYPE"; then
        ${xfsprogs}/bin/mkfs.xfs /dev/vda1 -L NIXOS_ROOT -m crc=0
      fi
    '';

    system.stateVersion = "24.05";
  };
}
