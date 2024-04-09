{lib, ...}: let
  userLib = import ./lib.nix {inherit lib;};
in {
  users.users."raf" = {
    uid = userLib.mkUid "rafi";
    openssh.authorizedKeys.keyFiles = [./keys/raf];
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "trusted"
    ];
  };
}
