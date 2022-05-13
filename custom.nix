let
  inherit (import ./default.nix { }) pkgs;
in
with pkgs; [
  prospector-177
  haproxy-2-2-9
  haproxy-2-2-23
]
