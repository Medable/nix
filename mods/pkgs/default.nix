{ pkgs ? import ../../default.nix { } }:
pkgs.mkShell {
  name = "mdctl-alpha-dev-shell";
  nativeBuildInputs = with pkgs; [
    nodejs_20
    nodejs_20.pkgs.yarn
    python3
    pkg-config
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    libsecret
    glib
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    xcbuild
    darwin.cctools
  ];
  env = {
    npm_config_nodedir = "${pkgs.nodejs_20.dev}";
    NODE_EXTRA_CA_CERTS = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };
}
