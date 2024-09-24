{
  modulesPath,
  config,
  pkgs,
  ...
}: let
  # https://unix.stackexchange.com/questions/16578/resizable-serial-console-window
  resize = pkgs.writeScriptBin "resize" ''
    if [ -e /dev/tty ]; then
      old=$(stty -g)
      stty raw -echo min 0 time 5
      printf '\033[18t' > /dev/tty
      IFS=';t' read -r _ rows cols _ < /dev/tty
      stty "$old"
      stty cols "$cols" rows "$rows"
    fi
  '';
in {
  imports = [(modulesPath + "/virtualisation/qemu-vm.nix")];

  environment = {
    systemPackages = [resize];
    loginShellInit = "${resize}/bin/resize";
  };

  virtualisation = {
    memorySize = 8000;
    diskSize = 200000;
    cores = 8;

    # Try to make this bootable.
    useBootLoader = true;

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

    # The VM will run on a headless machine.
    graphics = false;

    # mac addr can be anything, especially the last 3 bytes
    # the OUI is specific to QEMU
    qemu.networkingOptions = [
      "-device virtio-net-pci,netdev=user0,mac=52:54:00:00:00:00"
      "-netdev bridge,id=user0,br=br0"
    ];
  };
}
