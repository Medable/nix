{ pkgs ? import <nixpkgs> { }, nodejs ? pkgs.nodejs_18 }:

pkgs.callPackage ../mdctl/build.nix {
  inherit nodejs;
  packageDir = ./.;
  yarnHash = "sha256-r0gQXRsBrSUJeG/COyAQHPvuMSXC6uCK7k8uSjgQ/e8=";
}
