# hyprland-infra

<!--
    TODO: proper readme.
    Things we want:
      - Onboarding
      - Adding new services
      - Easier deployment (?)
-->

Hyprland Nix infrastructure. Contains non-critical services, which include but
is not limited to:

- Typhon (Nix build service)

## Networking setup

### Creating a bridge on the host

A bridge is needed to preserve bidirectional connectivity between the host and
the guest.

Get the current connection's link name. We'll use `<eth0>` throughout this file.

```bash
$ nmcli con show
```

```bash
$ nmcli con add ifname br0 type bridge con-name br0
$ nmcli con add type bridge-slave ifname <eth0> master br0
```

If using DHCP:

```bash
$ nmcli con mod br0 ipv4.method auto
```

If using static IPs:

```bash
$ nmcli con mod br0 ipv4.method manual
$ nmcli con mod br0 ipv4.addresses 10.1.1.16/24
$ nmcli con mod br0 ipv4.gateway 10.1.1.1
$ nmcli con mod br0 ipv4.dns '10.1.1.1,1.1.1.1'
```

We do not need Spanning Tree Protocol, disable it:

```bash
$ nmcli con mod br0 bridge.stp no
```

Turn up the bridge:

```bash
$ nmcli con down <eth0>
$ nmcli con up br0
```

To disable `<eth0>` autoconnect and let the bridge do the connection instead:

```bash
$ nmcli con mod <eth0> connection.autoconnect no
```

<!--
    TODO(fufexan): research and add systemd-networkd sample code
    - raf: The host does not run systemd-networkd. Good to have
    but definitely not a priority.
-->

### Setting up QEMU to allow bridges

In `/etc/qemu/bridge.conf` write `allow br0`.
