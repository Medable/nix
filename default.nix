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
      config = { allowUnfree = true; } // config;
      overlays = [ (_: _: { inherit jacobi; }) ] ++ (import ./mods/default.nix) ++ overlays;
    }
, jacobi ? import
    (fetchTarball {
      inherit (jpetrucciani_pin) sha256;
      name = "jpetrucciani-${jpetrucciani_pin.date}";
      url = "https://github.com/jpetrucciani/nix/archive/${jpetrucciani_pin.rev}.tar.gz";
    })
    { inherit overlays config system; }
, overlays ? [ ]
, config ? { }
, system ? builtins.currentSystem
}:
let
  name = "medable";

  tools = with pkgs; {
    cli = [
      bashInteractive
      curl
      delta
      dyff
      git
      gron
      jq
      just
      (with jacobi; [
        batwhich
        hax.comma
        get_cert
      ])
    ];
    formatting = [
      nixpkgs-fmt
      nodePackages.prettier
    ];
    hashers = with jacobi; [
      nix_hash_jpetrucciani
      nix_hash_medable
      nix_hash_unstable
    ];
    medable = [
      mdctl
    ];
    nix = [
      statix
      jacobi.hex
      jacobi.hexrender
    ];
    scripts = [
      (writeShellScriptBin "test_actions" ''
        ${pkgs.act}/bin/act --container-architecture linux/amd64 --artifact-server-path ./.cache/ -r --rm
      '')
    ];
  };

  paths = pkgs.lib.flatten [ (builtins.attrValues tools) ];
  env = pkgs.buildEnv {
    inherit name paths;
    buildInputs = paths;
  };
in
pkgs // pkgs.custom // {
  inherit jacobi;
  inherit (jacobi) batwhich get_cert github_tags gke_config gke-gcloud-auth-plugin;
  inherit (jacobi) portwatch __rd __rd_shell __pg_bootstrap __pg_shell __pg __run;
  inherit (jacobi) pog hex hexrender nixup nix_hash_medable nix_hash_jpetrucciani;
  inherit (jacobi) _zaddy zaddy zaddy-browser;
  ktools = jacobi.k8s_pog_scripts;
  dtools = jacobi.docker_pog_scripts;
}
