final: prev:
with prev;
rec {
  inherit (stdenv) isLinux isDarwin isAarch64;

  nodejs-14_x = nodejs-14_20_0;
  nodejs-14_20_0 = (import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/ee01de29d2f58d56b1be4ae24c24bd91c5380cea.tar.gz";
      sha256 = "0829fqp43cp2ck56jympn5kk8ssjsyy993nsp0fjrnhi265hqps7";
    })
    { }).nodejs-14_x;

  nodejs-16_x = nodejs-16_20_0;
  nodejs-16_20_0 = (import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/eb5e3816eafb761d3db8323bbd0f6d2737cf77d7.tar.gz";
      sha256 = "0h154c6ybmqaidv8zzi8lbrn961psq79q2aqbq8pna3jcym2n5r4";
    })
    {
      config = {
        permittedInsecurePackages = [
          "nodejs-16.20.2"
        ];
      };
    }).nodejs_16;

  nodejs-18_x = nodejs-18_20_6;
  nodejs-18_20_6 = (import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/4457f3606c598ae825fb4b185b65a464d9d07a16.tar.gz";
      sha256 = "0padq6kva9s2d0xsn7alsivswl4g37a781yyv59vlwf4iv2i1n4l";
    })
    { }).nodejs_18;

  custom = prev.custom // {
    inherit nodejs-14_x nodejs-16_x nodejs-18_x;
    nodejs_14 = nodejs-14_20_0;
    nodejs_16 = nodejs-16_20_0;
    nodejs_18 = nodejs-18_20_6;
  };
}
