prev: next:
with next;
rec {
  inherit (stdenv) isLinux isDarwin isAarch64;

  prospector-177 = (import
    (fetchFromGitHub {
      name = "frozen-prospector";
      owner = "jpetrucciani";
      repo = "nix";
      rev = "58e698a20ba4cc8b58a9e08e359cc413e2868a6b";
      sha256 = "02z5hmbh0zag6smzsyd1pxgzzw84vnrdiqww3jyk3iwk6abkzjh6";
    })
    { }).prospector-176;


  # haproxy overrides
  haproxy-pin = { version, sha256 }: haproxy.overrideAttrs (attrs: rec {
    inherit version;
    src = fetchurl {
      inherit sha256;
      url = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/${attrs.pname}-${version}.tar.gz";
    };
  });
  haproxy-2-2-9 = haproxy-pin {
    version = "2.2.9";
    sha256 = "sha256-IWgEWbCLm6IcjMn129DubhhC9Xo6Z/hxeYceHBPr1OM=";
  };
  haproxy-2-2-23 = haproxy-pin {
    version = "2.2.23";
    sha256 = "sha256-3lc7eGtm7izLmnmiN7DpHTwnokchR0+VadWHjo651Po=";
  };
}
