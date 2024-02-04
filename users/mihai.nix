{lib, ...}: let
  userLib = import ./lib.nix {inherit lib;};
in {
  users.users.mihai = {
    openssh.authorizedKeys.keyFiles = [./keys/mihai];
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "trusted"
    ];
    uid = userLib.mkUid "mihi";
  };
}
