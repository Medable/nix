{ pkgs ? import <nixpkgs> { }, nodejs ? pkgs.nodejs_18 }:

pkgs.callPackage ./build.nix {
  inherit nodejs;
  packageDir = ./.;
  yarnHash = "sha256-x+2xnVQauJ2APlumU1sPsdU6L65bsJ6GxsjAJXNIovQ=";
}
