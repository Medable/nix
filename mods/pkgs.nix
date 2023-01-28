final: prev:
with prev;
rec {
  inherit (stdenv) isLinux isDarwin isAarch64;

  # haproxy overrides
  haproxy-pin = { version, sha256 }: haproxy.overrideAttrs (attrs: rec {
    inherit version;
    src = fetchurl {
      inherit sha256;
      url = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/${attrs.pname}-${version}.tar.gz";
    };
  });
  haproxy-2-2-23 = haproxy-pin {
    version = "2.2.23";
    sha256 = "sha256-3lc7eGtm7izLmnmiN7DpHTwnokchR0+VadWHjo651Po=";
  };
  haproxy-2-2-24 = haproxy-pin {
    version = "2.2.24";
    sha256 = "sha256-DoBzENzjpSk9JFTZwbceuNFkcjBbZvB2s4S1CFix5/k=";
  };
  haproxy-2-2-25 = haproxy-pin {
    version = "2.2.25";
    sha256 = "sha256-vrQH6wiyxpfRFaGMANagI/eg+yy5m/+cNMnf2dLFLys=";
  };
  haproxy-2-2-26 = haproxy-pin {
    version = "2.2.26";
    sha256 = "sha256-anKoZn8qWvsAyjT+vxOLpqG/BMNb2xtyXS55qS982Vk=";
  };
  haproxy-2-6-7 = haproxy-pin {
    version = "2.6.7";
    sha256 = "sha256-z/m4sYpSv+wnf5wYh/rJPBjhufPv9IiSJVp8bmRSi30=";
  };
  haproxy-2-7-1 = haproxy-pin {
    version = "2.7.1";
    sha256 = "sha256-FV86L7bfwf39E9lGomCrjdKhN3FKy4GFEHSeP/trNR0=";
  };

  # we need nodejs 14 back
  nodejs-14_x = nodejs-14_20_0;
  nodejs-14_20_0 = (import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/ee01de29d2f58d56b1be4ae24c24bd91c5380cea.tar.gz";
      sha256 = "0829fqp43cp2ck56jympn5kk8ssjsyy993nsp0fjrnhi265hqps7";
    })
    { }).nodejs-14_x;

  custom = [
    haproxy-2-2-23
    haproxy-2-2-24
    haproxy-2-2-25
    haproxy-2-2-26
    haproxy-2-6-7
    haproxy-2-7-1
    nodejs-14_x
  ];
}
