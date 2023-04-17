# mods

This directory contains our overlays for nixpkgs, but is set up in a way that others can reuse specific parts of our overlays if they'd like to use this repo as a source.

---

## In this directory

### [pkgs/](./pkgs/)

Custom packages provided by medable

### [python/](./python/)

This directory contains python specific overrides that medable uses.

### [\_pkgs.nix](./_pkgs.nix)

This overlay allows us to load our custom pkgs within the [pkgs directory](./pkgs/)

### [cloud.nix](./cloud.nix)

This overlay contains various cloud-related cli tools

### [default.nix](./default.nix)

This overlay combines the others into a single import for the top level [default.nix](../default.nix)

### [haproxy.nix](./haproxy.nix)

This overlay contains many versions of haproxy

### [node.nix](./node.nix)

This overlay contains specific versions of node we may want to pin
