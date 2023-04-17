# nix

[![uses nix](https://img.shields.io/badge/uses-nix-%237EBAE4)](https://nixos.org/)

This repo represents channel pins and overlays that we use at Medable!

---

# mdctl!

If you're looking for an easy way to use mdctl without the node/nvm environment hassle, try out nix!

```bash
# install mdctl to your nix-env (kinda like brew install!)
nix-env -f https://github.com/medable/nix/archive/main.tar.gz -iA mdctl

# temporary shell with mdctl!
nix-shell -A mdctl https://github.com/medable/nix/archive/main.tar.gz
```

There is also an attribute `mdctl-alpha`, which is independently updated as well!

---

## In this repo

### [.github/](./.github/)

This directory contains our GitHub actions, which are used to automatically check for updates to various sources, and rebuild and cache our nix setups for multiple platforms.

### [mods/](./mods/)

This directory contains our overlays for nixpkgs, but is set up in a way that others can reuse specific parts of our overlays if they'd like to use this repo as a source.

### [pins/](./pins/)

This directory contains rev/sha256 combos for any of the other repos that we track and pin in this repo. These can be automatically updated with GitHub actions!

### [default.nix](./default.nix)

This file acts as the entrypoint for nix to pin our nixpkgs version to the rev and sha256 found [in the pins directory](./pins).
