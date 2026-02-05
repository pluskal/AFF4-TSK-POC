# INTRO:
Proof of concept implementation of AFF4 backend used by TSK library. Additionally with mapping to C# using P/Invoke.

# Dependencies
- [https://github.com/aff4/aff4-cpp-lite/tree/master](https://github.com/aff4/aff4-cpp-lite/tree/master)
- [https://github.com/sleuthkit/sleuthkit](https://github.com/sleuthkit/sleuthkit)

## Nix/NixOS
This repository ships a Nix flake that builds the shared library and packages
`aff4-cpp-lite` from GitHub. You can build the library with:

```sh
nix build
```

To build the aff4-cpp-lite dependency directly:

```sh
nix build .#aff4-cpp-lite
```
