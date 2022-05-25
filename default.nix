with builtins;
{ load_pin ? x: fromJSON (readFile x)
, nixpkgs_pin ? load_pin ./pins/nixpkgs.json
, jpetrucciani_pin ? load_pin ./pins/jpetrucciani.json
, pkgs ? import
    (
      fetchTarball {
        inherit (nixpkgs_pin) sha256;
        name = "nixpkgs-unstable-${nixpkgs_pin.date}";
        url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgs_pin.rev}.tar.gz";
      }
    )
    {
      config = {
        allowUnfree = true;
      };
      overlays = [ (_: _: { inherit jacobi; }) ] ++ (import ./overlays.nix) ++ overlays;
    }
, jacobi ? import
    (
      fetchTarball {
        inherit (jpetrucciani_pin) sha256;
        name = "jpetrucciani-${jpetrucciani_pin.date}";
        url = "https://github.com/jpetrucciani/nix/archive/${jpetrucciani_pin.rev}.tar.gz";
      }
    )
    { nixpkgs = pkgs.path; }
, overlays ? [ ]
}:
let
  tools = with pkgs; {
    cli = lib.flatten [
      bashInteractive_5
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
    medable = with jacobi; [
      mdctl
    ];
    nix = [
      statix
    ];
  };

  packages = pkgs.lib.flatten [
    (pkgs.lib.flatten (attrValues tools))
  ];

  env = pkgs.buildEnv {
    name = "medable-nix";
    paths = packages;
    buildInputs = packages;
  };
in
env // { inherit pkgs jacobi; }
