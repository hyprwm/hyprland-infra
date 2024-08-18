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

    qemu.networkingOptions = [
      "-net nic,netdev=user.0,model=virtio"
      "-netdev user,id=user.0,\${QEMU_NET_OPTS:+,$QEMU_NET_OPTS}"
      "hostfwd=tcp::2222-:2222"
    ];
  };
}
