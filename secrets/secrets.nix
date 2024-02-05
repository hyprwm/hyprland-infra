let
  getKeys = target: map (v: "${toString v}") (builtins.split "\n" (builtins.readFile target));

  raf = getKeys ../users/keys/raf;
  fufexan = getKeys ../users/keys/mihai;
  admin = [raf fufexan];

  caesar = "";
  systems = [caesar];
in {
  "secret1.age".publicKeys = admin;
  "secret2.age".publicKeys = admin ++ systems;
}
