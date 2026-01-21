{ pkgs ? import <nixpkgs> { }, nodejs ? pkgs.nodejs_20 }:
with pkgs; with lib; with builtins;
let
  yarn2nix = yarn2nix-moretea.override { inherit nodejs; };
  osSpecific = if pkgs.stdenv.isDarwin then [ xcbuild darwin.cctools ] else [ ];
  json = fromJSON (readFile ./package.json);
  pname = replaceStrings [ "@" "/" ] [ "" "-" ] (head (attrNames json.dependencies));
  version = head (attrValues json.dependencies);
  keytarRuntimeLibs = lib.optionals stdenv.isLinux [
    libsecret
    glib
    stdenv.cc.cc.lib
    zlib
    openssl
    libffi
    pcre2
  ];
  linuxRpath = lib.makeLibraryPath keytarRuntimeLibs;
  modules = (yarn2nix.mkYarnModules {
    inherit version;
    pname = "${pname}-modules";
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    pkgConfig = {
      keytar = {
        buildInputs = [
          python3
          pkg-config
        ] ++ lib.optionals stdenv.isLinux [
          libsecret
          glib
          patchelf
        ] ++ osSpecific;
      };
      sqlite3.buildInputs = [ python3 pkg-config ];
    };
    postBuild = ''
      cd $out
      export npm_config_nodedir="${nodejs.dev}"
      npm rebuild keytar sqlite3
    '';
  }).overrideAttrs (old: {
    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    postFixup = (old.postFixup or "") + lib.optionalString pkgs.stdenv.isLinux ''
      echo "Patching RPATH for native addons -> ${linuxRpath}"
      while IFS= read -r -d "" f; do
        if file "$f" | grep -q ELF; then
          old_rpath="$(patchelf --print-rpath "$f" 2>/dev/null || true)"
          if [ -n "$old_rpath" ]; then
            patchelf --set-rpath "${linuxRpath}:$old_rpath" "$f" || true
          else
            patchelf --set-rpath "${linuxRpath}" "$f" || true
          fi
        fi
      done < <(find "$out/node_modules" -type f -name '*.node' -print0)
    '';
  });
in
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${modules}/node_modules/pkg/node_modules/.bin/mdctl $out/bin
  '';
}
