final: prev:
with prev;
rec {
  inherit (stdenv) isLinux isDarwin isAarch64;

  # we need nodejs 14 back
  nodejs-14_x = nodejs-14_20_0;
  nodejs-14_20_0 = (import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/ee01de29d2f58d56b1be4ae24c24bd91c5380cea.tar.gz";
      sha256 = "0829fqp43cp2ck56jympn5kk8ssjsyy993nsp0fjrnhi265hqps7";
    })
    { }).nodejs-14_x;

  custom = prev.custom // {
    inherit nodejs-14_x;
    nodejs_14 = nodejs-14_20_0;
  };
}
