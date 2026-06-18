{ pkgs ? import ../../default.nix { } }:
pkgs.mkShell {
  name = "mdctl-alpha-dev-shell";
  nativeBuildInputs = with pkgs; [
    nodejs_18
    nodejs_18.pkgs.yarn
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
    npm_config_nodedir = "${pkgs.nodejs_18}";
    NODE_EXTRA_CA_CERTS = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };
}
