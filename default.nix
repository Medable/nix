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
      config = {
        allowUnfree = true;
      };
      overlays = [ (_: _: { inherit jacobi; }) ] ++ (import ./mods/default.nix) ++ overlays;
    }
, jacobi ? import
    (fetchTarball {
      inherit (jpetrucciani_pin) sha256;
      name = "jpetrucciani-${jpetrucciani_pin.date}";
      url = "https://github.com/jpetrucciani/nix/archive/${jpetrucciani_pin.rev}.tar.gz";
    })
    { }
, overlays ? [ ]
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
env // pkgs.custom // {
  inherit pkgs jacobi;
  inherit (jacobi) portwatch __rd __rdshell __pg_bootstrap __pg_shell __pg __run;
  inherit (jacobi) pog hex hexrender nix_hash_medable;
  inherit (jacobi) _zaddy zaddy zaddy-browser;
}
