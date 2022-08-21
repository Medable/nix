final: prev:
with prev;
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
  haproxy-2-2-24 = haproxy-pin {
    version = "2.2.24";
    sha256 = "sha256-DoBzENzjpSk9JFTZwbceuNFkcjBbZvB2s4S1CFix5/k=";
  };
  haproxy-2-2-25 = haproxy-pin {
    version = "2.2.25";
    sha256 = "sha256-vrQH6wiyxpfRFaGMANagI/eg+yy5m/+cNMnf2dLFLys=";
  };
  haproxy-2-6-2 = haproxy-pin {
    version = "2.6.2";
    sha256 = "sha256-+bfcBuAusTtdlNxm4IZKcUruKvnfqxD6NT/58fUsggI=";
  };

  awscli2 = prev.awscli2.override {
    python3 = prev.awscli2.python // {
      override = args: prev.awscli2.python.override (args // {
        packageOverrides = self: super: args.packageOverrides self super // (
          if stdenv.isDarwin
          then {
            twisted = super.twisted.overrideAttrs (_: { doInstallCheck = false; });
            pyopenssl = super.pyopenssl.overrideAttrs (_: { meta.broken = false; });
          }
          else { }
        );
      });
    };
  };

  custom = [
    prospector-177
    haproxy-2-2-9
    haproxy-2-2-24
    haproxy-2-2-23
    haproxy-2-2-25
    awscli2
  ];
}
