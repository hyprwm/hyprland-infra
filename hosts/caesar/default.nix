{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  config = {
    zramSwap.enable = lib.mkForce false;
    services.thermald.enable = lib.mkForce false;

    boot = {
      initrd.supportedFilesystems = ["ext4"];

      kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      promptInit = ''
        eval "$(${lib.getExe pkgs.starship} init zsh)"
      '';
    };

    virtualisation = {
      memorySize = 8000;
      diskSize = 200000;
      cores = 8;

      # fs
      useDefaultFilesystems = false;
      rootDevice = "/dev/disk/by-label/NIXOS_ROOT";

      fileSystems = {
        "/" = {
          device = "${config.virtualisation.rootDevice}";
          fsType = "xfs";
        };
      };

      interfaces = {
        vm0.vlan = 1;
      };
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
