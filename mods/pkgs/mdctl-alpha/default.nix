{ pkgs ? import <nixpkgs> { }, nodejs ? pkgs.nodejs_22 }:
with pkgs; with lib; with builtins;
let
  yarn2nix = yarn2nix-moretea.override { inherit nodejs; };
  osSpecific = with pkgs.darwin.apple_sdk.frameworks; if pkgs.stdenv.isDarwin then [ Security AppKit xcbuild darwin.cctools ] else [ ];
  json = fromJSON (readFile ./package.json);
  pname = replaceStrings [ "@" "/" ] [ "" "-" ] (head (attrNames json.dependencies));
  version = head (attrValues json.dependencies);
  nodedir = runCommand "nodedir" { } ''
    tar xvf ${nodejs.src}
    mv node-* $out
  '';
  modules = yarn2nix.mkYarnModules {
    inherit version;
    pname = "${pname}-modules";
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    pkgConfig.mdctl.buildInputs = [
      gcc
      glib
      gnumake
      libsecret
      nodejs.pkgs.node-gyp
      nodejs.pkgs.node-pre-gyp
      pkg-config
      python311
      (lib.flatten osSpecific)
    ];
    postBuild = "cd $out && npm rebuild --nodedir=${nodedir} keytar sqlite3";
  };
in
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${modules}/node_modules/pkg/node_modules/.bin/mdctl $out/bin
  '';
}
