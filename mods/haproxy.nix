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
  haproxy-2-7-2 = haproxy-pin {
    version = "2.7.2";
    sha256 = "sha256-Y7xuwDAtDrvh+nacGWBmQN6DSsjLB0R7gHmctWPcDz8=";
  };

  custom = prev.custom // {
    inherit haproxy-2-2-23 haproxy-2-2-24 haproxy-2-2-25 haproxy-2-2-26 haproxy-2-2-27 haproxy-2-2-28 haproxy-2-2-29 haproxy-2-7-2;
  };
}
