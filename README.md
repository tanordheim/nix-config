# setup notes

- set the machine name to harahorn
- install nix (`$ sh <(curl -L https://nixos.org/nix/install)`)
- set initial nix config (`mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`)
- clone repo
- run `make darwin-rebuild`

## inspirations

- https://github.com/joaquingatica/nix-darwin/tree/main
- https://github.com/z0al/dotfiles/tree/main
- https://github.com/caarlos0/dotfiles (vim stuff)
- https://codeberg.org/RockWolf/dotfiles (private+public config)
- https://github.com/crissNb/dotfiles/tree/main (sketchybar)
