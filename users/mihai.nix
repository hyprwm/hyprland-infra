{lib, ...}: let
  userLib = import ./lib.nix {inherit lib;};
in {
  users.users."mihai" = {
    uid = userLib.mkUid "mihi";
    openssh.authorizedKeys.keyFiles = [./keys/mihai];
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "trusted"
    ];
  };
}
