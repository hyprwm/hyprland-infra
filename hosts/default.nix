{self, ...}: let
  inherit (self) inputs;

  # TODO: move to standalone lib directory
  mkSystem = inputs.nixpkgs.lib.nixosSystem;

  # mkNixosSystem wraps mkSystem (a.k.a lib.nixosSystem) with flake-parts' withSystem to provide inputs' and self' from flake-parts
  # it also acts as a template for my nixos hosts with system type and modules being imported beforehand
  # specialArgs is also defined here to avoid defining them for each host and lazily merged if the host defines any other args
  mkNixosSystem = {
    modules,
    system,
    hostname,
    ...
  } @ args:
    mkSystem {
      inherit system;
      modules = {networking.hostName = hostname;} // args.modules or {};
      specialArgs = {inherit inputs self;} // args.specialArgs or {};
    };
in {
  "caesar" = mkNixosSystem {
    hostname = "caesar";
    system = "x86_64-linux";
    modules = [
      ./caesar
    ];
  };
}
