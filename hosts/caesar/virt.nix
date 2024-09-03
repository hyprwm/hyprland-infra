{
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/virtualisation/qemu-vm.nix")];

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

    # mac addr can be anything, especially the last 3 bytes
    # the OUI is specific to QEMU
    qemu.networkingOptions = [
      "-device virtio-net-pci,netdev=user0,mac=52:54:00:00:00:00"
      "-netdev bridge,id=user0,br=br0"
    ];
  };
}
