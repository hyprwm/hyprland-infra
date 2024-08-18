{pkgs, ...}: let
  asGB = size: toString (size * 1024 * 1024 * 1024);
in {
  nix = {
    # useful for ad-hoc nix-shell's for debugging
    # use mkForce to avoid search path warnings with nix-darwin
    nixPath = pkgs.lib.mkForce ["nixpkgs=${pkgs.path}"];

    # Hard-link duplicated files
    settings = {
      auto-optimise-store = true;

      # auto-free the /nix/store
      min-free = asGB 10;
      max-free = asGB 50;
    };

    gc = {
      automatic = true;
      options = pkgs.lib.mkDefault "--delete-older-than 14d";
    };
  };
}
