final: prev:
let
  inherit (builtins) listToAttrs pathExists readDir;
  inherit (prev.lib) hasPrefix hasSuffix mapAttrsToList optionalAttrs removeSuffix;
  inherit (prev.lib.attrsets) filterAttrs;
  nodePkgs = prev.custom.nodejs_18_pkgs;
  packagePkgs = n: if hasPrefix "mdctl" (removeSuffix ".nix" n) then nodePkgs else prev.pkgs;
  custom =
    (
      fn:
      optionalAttrs (pathExists ./pkgs)
        (listToAttrs (mapAttrsToList fn (filterAttrs (k: v: (v == "directory") || ((hasSuffix ".nix" k) && k != "default.nix")) (readDir ./pkgs))))
    ) (
      n: _: {
        name = removeSuffix ".nix" n;
        value =
          let
            pkgs = packagePkgs n;
          in
          pkgs.callPackage (./pkgs + ("/" + n))
            ({
              inherit pkgs;
            } // optionalAttrs (hasPrefix "mdctl" (removeSuffix ".nix" n)) {
              nodejs = pkgs.nodejs_18;
            });
      }
    );
in
{
  inherit custom;
} // custom
