{config, ...}: let
  # Assume first port in the list is the default port. This makes sense only if openssh
  # is bound to a single port. This is, ultimately, non-deterministic.
  sshPort = builtins.elemAt config.services.openssh.ports 0;
in {
  networking = {
    firewall.enable = true; # defaults to true, but enable anyway

    nftables = {
      enable = true;
      tables = {
        filter = {
          family = "inet";
          # Check out https://wiki.nftables.org/ for better documentation.
          # Table for both IPv4 and IPv6.
          content = ''
            # Block all incoming connections traffic except SSH and "ping".
            chain input {
              type filter hook input priority 0;

              # accept any localhost traffic
              iifname lo accept

              # accept traffic originated from us
              ct state {established, related} accept

              # ICMP
              # routers may also want: mld-listener-query, nd-router-solicit
              ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
              ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

              # allow "ping"
              ip6 nexthdr icmpv6 icmpv6 type echo-request accept
              ip protocol icmp icmp type echo-request accept

              # accept SSH connections (required for a server)
              tcp dport ${sshPort} accept comment "Accept SSH connections"

              # count and drop any other traffic
              counter drop
            }

            # Allow all outgoing connections.
            chain output {
              type filter hook output priority 0;
              accept
            }

            chain forward {
              type filter hook forward priority 0;
              accept
            }
          '';
        };
      };
    };
  };
}
