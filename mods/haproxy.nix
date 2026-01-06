final: prev:
let
  inherit (prev.stdenv) isLinux isDarwin isAarch64;
  haproxy-pin = { version, sha256 }:
    let
      pre3 = (builtins.compareVersions version "3.0.0") == -1;
      pre2-2-33 = (builtins.compareVersions version "2.2.33") == -1;
      _haproxy = if pre3 then prev.haproxy2 else prev.haproxy;
    in
    _haproxy.overrideAttrs (old: rec {
      inherit version;
      src = prev.fetchurl {
        inherit sha256;
        url = "https://www.haproxy.org/download/${prev.lib.versions.majorMinor version}/src/${old.pname}-${version}.tar.gz";
      };
    });
  versions = {
    "2.2.33" = "sha256-JPnuwE7o2eNlI3C+PbmFLeyKplCzyO6ulpMAyGtv2ls=";
    "2.2.34" = "sha256-D7eNHylsRcdUapoxZ9WV+xr56vnpwWqTJPNsVfvy8yM=";
  };
  haproxyMap = prev.lib.mapAttrs' (k: v: { name = "haproxy-${builtins.replaceStrings ["."] ["-"] k}"; value = haproxy-pin { version = k; sha256 = v; }; }) versions;
in
haproxyMap // {
  custom = prev.custom // haproxyMap;
}
