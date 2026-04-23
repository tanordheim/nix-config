# Installing

1. Set the correct hostname/computer name
2. (if on MacOS) Install Nix using the Lix installer: `curl -sSf -L https://install.lix.systems/lix | sh -s -- install`
3. Clone this repository.
4. Run `./rebuild` (platform-detecting wrapper — runs `darwin-rebuild` or `nixos-rebuild` as appropriate).

## inspirations

- https://github.com/joaquingatica/nix-darwin/tree/main
- https://github.com/z0al/dotfiles/tree/main
- https://github.com/caarlos0/dotfiles (vim stuff)
- https://codeberg.org/RockWolf/dotfiles (private+public config)
- https://github.com/crissNb/dotfiles/tree/main (sketchybar)
- https://github.com/sumnerevans/home-manager-config (vim stuff)
- https://github.com/maximbaz/dotfiles (structure)
- https://github.com/mightyiam/infra (dendritic pattern)
- https://github.com/lewisflude/nix (dendritic pattern, multi-platform)
