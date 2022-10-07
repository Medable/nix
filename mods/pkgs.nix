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
  haproxy-2-6-5 = haproxy-pin {
    version = "2.6.5";
    sha256 = "sha256-zp4Z6/zdQ+Ua+KYJDx341RLZct33QvpkimQ7uxkFZgU=";
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

  # we need nodejs 14 back
  nodejs-14_x = nodejs-14_19_1;
  nodejs-14_19_1 = (import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/d1c3fea7ecbed758168787fe4e4a3157e52bc808.tar.gz";
      sha256 = "0ykm15a690v8lcqf2j899za3j6hak1rm3xixdxsx33nz7n3swsyy";
    })
    { }).nodejs-14_x;

  custom = [
    prospector-177
    haproxy-2-2-23
    haproxy-2-2-24
    haproxy-2-2-25
    haproxy-2-6-5
    awscli2
    nodejs-14_x
  ];
}
