final: prev:
rec {
  inherit (prev.stdenv) isLinux isDarwin isAarch64;

  # haproxy overrides
  haproxy-pin = { version, sha256 }:
    let
      oldDeps = if isLinux then [ final.systemd ] else [ ];
      pre3 = (builtins.compareVersions version "3.0.0") == -1;
    in
    prev.haproxy.overrideAttrs (old: rec {
      inherit version;
      src = prev.fetchurl {
        inherit sha256;
        url = "https://www.haproxy.org/download/${prev.lib.versions.majorMinor version}/src/${old.pname}-${version}.tar.gz";
      };
      buildInputs = old.buildInputs ++ (if pre3 then oldDeps else [ ]);
      buildFlags = old.buildFlags ++ (if pre3 then [ "EXTRA_OBJS=contrib/prometheus-exporter/service-prometheus.o" ] else [ ]);
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
  haproxy-2-2-27 = haproxy-pin {
    version = "2.2.27";
    sha256 = "sha256-eVg84n7Y898KQVp2Gmt7AU4+pYLmxKMkqC6cJ+RiF9Y=";
  };
  haproxy-2-2-28 = haproxy-pin {
    version = "2.2.28";
    sha256 = "sha256-VzR2bGHtF3xdtvHl9A3UPMU5wiRSxp1zqKdO9chggjU=";
  };
  haproxy-2-2-29 = haproxy-pin {
    version = "2.2.29";
    sha256 = "sha256-HkH0lnT79WY7VcX3kZp9BeSAcwZT8rzew4S4g278H7A=";
  };


  custom = prev.custom // {
    inherit haproxy-2-2-23 haproxy-2-2-24 haproxy-2-2-25 haproxy-2-2-26 haproxy-2-2-27 haproxy-2-2-28 haproxy-2-2-29;
  };
}
