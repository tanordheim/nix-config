{
  description = "NixOS and nix-darwin config for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Nix-darwin (for macOS machines)
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin color scheme
    catppuccin.url = "github:catppuccin/nix";

    # Homebrew
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private config
    nix-config-private = {
      url = "git+ssh://git@github.com/tanordheim/nix-config-private.git?ref=main";
      # url = "git+file:///Users/trond/Code/nix-config-private?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    homebrew-aerospace,
    nix-homebrew,
    nix-config-private,
    ...
  } @ inputs:
  let
    inherit (self) outputs;

    # Helper function for nix-darwin system configuration
    mkDarwinConfiguration = hostname:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit (inputs) catppuccin home-manager homebrew-core homebrew-cask homebrew-bundle homebrew-aerospace;
          isDarwin = true;
        };
        modules =
	[
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/default.nix
	  ./platforms/darwin
        ]
	++ (builtins.attrValues nix-config-private.outputs.homeManagerModules)
	++ (builtins.attrValues nix-config-private.outputs.nixModules);
      };

  in {
    darwinConfigurations = {
      "harahorn-mac" = mkDarwinConfiguration "harahorn-mac";
    };
  };
}
