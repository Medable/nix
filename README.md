# nix

[![uses nix](https://img.shields.io/badge/uses-nix-%237EBAE4)](https://nixos.org/)

This repo represents channel pins and overlays that we use at Medable!

---

## In this repo

### [.github/](./.github/)

This directory contains our GitHub actions, which are used to automatically check for updates to various sources, and rebuild and cache our nix setups for multiple platforms.

### [mods/](./mods/)

This directory contains our overlays for nixpkgs, but is set up in a way that others can reuse specific parts of our overlays if they'd like to use this repo as a source.

### [pins/](./pins/)

This directory contains rev/sha256 combos for any of the other repos that we track and pin in this repo. These can be automatically updated with GitHub actions!

### [default.nix](./default.nix)

This file acts as the entrypoint for nix to pin our nixpkgs version to the rev and sha256 found [in the sources directory](./sources/nixpkgs.json).

### [overlays.nix](./overlays.nix)

This file declares the overlays that we apply to our pinned version of nixpkgs. This should load all of the files in the [mods](./mods/) directory, which are overlay functions which apply to our nixpkgs object in nix.
