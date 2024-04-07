{ load_pin ? x: builtins.fromJSON (builtins.readFile x)
, nixpkgs_pin ? load_pin ./pins/nixpkgs.json
, jpetrucciani_pin ? load_pin ./pins/jpetrucciani.json
, pkgs ? import
    (fetchTarball {
      inherit (nixpkgs_pin) sha256;
      name = "nixpkgs-unstable-${nixpkgs_pin.date}";
      url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgs_pin.rev}.tar.gz";
    })
    {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "nodejs-16.20.2"
        ];
      } // config;
      overlays = [ (_: _: { inherit jacobi; }) ] ++ (import ./mods/default.nix) ++ overlays;
    }
, jacobi ? import
    (fetchTarball {
      inherit (jpetrucciani_pin) sha256;
      name = "jpetrucciani-${jpetrucciani_pin.date}";
      url = "https://github.com/jpetrucciani/nix/archive/${jpetrucciani_pin.rev}.tar.gz";
    })
    { inherit config system; }
, overlays ? [ ]
, python_overlays ? [ ]
, config ? { }
, system ? builtins.currentSystem
}:
let
  packageOverrides = pkgs.lib.composeManyExtensions (jacobi.python311.overlays ++ [
    (import ./mods/python/china.nix)
  ] ++ python_overlays);
  python311 = pkgs.python311.override { self = python311; inherit packageOverrides; };
  python312 = pkgs.python312.override { self = python312; inherit packageOverrides; };
  python313 = pkgs.python313.override { self = python313; inherit packageOverrides; };
  python = python311;

  jacobi_tools = {
    inherit (jacobi) batwhich get_cert github_tags gke_config gke-gcloud-auth-plugin;
    inherit (jacobi) portwatch __rd __rd_shell __pg_bootstrap __pg_shell __pg __run;
    inherit (jacobi) pog hex hexcast nixup nix_hash_medable nix_hash_jpetrucciani;
    inherit (jacobi) srv _zaddy zaddy zaddy-browser;
    inherit (jacobi) poetry2nix;
  };
in
pkgs // pkgs.custom // jacobi_tools // {
  inherit jacobi jacobi_tools python python311 python312 python313;
  ktools = jacobi.k8s_pog_scripts;
  dtools = jacobi.docker_pog_scripts;
}
