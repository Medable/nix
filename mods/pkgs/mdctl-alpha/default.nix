{ pkgs ? import <nixpkgs> { }, nodejs ? pkgs.nodejs_20 }:
with pkgs; with lib; with builtins;
let
  yarn2nix = yarn2nix-moretea.override { inherit nodejs; };
  osSpecific = if pkgs.stdenv.isDarwin then [ xcbuild darwin.cctools ] else [ ];
  json = fromJSON (readFile ./package.json);
  pname = replaceStrings [ "@" "/" ] [ "" "-" ] (head (attrNames json.dependencies));
  version = head (attrValues json.dependencies);
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
