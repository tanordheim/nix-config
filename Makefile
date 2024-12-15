.PHONY: darwin-rebuild nixos-rebuild

darwin-rebuild:
	nix run nix-darwin -- switch --flake .

nixos-rebuild:
	sudo nixos-rebuild switch --impure --flake .
