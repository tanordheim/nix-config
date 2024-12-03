.PHONY: darwin-rebuild

darwin-rebuild:
	nix run nix-darwin -- switch --flake .
