{
  description = "NixOS and nix-darwin config for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # WORKAROUND: claude-code 2.1.257 (Fable 5.1) not yet in nixpkgs, https://github.com/NixOS/nixpkgs/pull/558900
    nixpkgs-claude-code-pr = {
      url = "github:NixOS/nixpkgs?ref=pull/558900/head";
      flake = false;
    };

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

    # Nixvim vim config management
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim plugins not yet packaged in nixpkgs
    tiny-cmdline-nvim = {
      url = "github:rachartier/tiny-cmdline.nvim";
      flake = false;
    };
    tiny-code-action-nvim = {
      url = "github:rachartier/tiny-code-action.nvim";
      flake = false;
    };
    herdr-nvim-nav = {
      url = "github:aimdevlee/herdr-nvim-nav/v1.0.0";
      flake = false;
    };

    # Aurral — music discovery/request manager for Lidarr
    aurral-src = {
      url = "github:lklynet/aurral/v1.50.1";
      flake = false;
    };

    # Stylix system wide color scheming/styling
    stylix.url = "github:danth/stylix";

    # Herdr — agent-aware terminal multiplexer (AGPL-3.0 / commercial dual-licensed)
    # WORKAROUND: post-0.8.0 builds turn AltGr/Level-3 characters into base keys in Kitty-aware panes.
    herdr = {
      url = "github:ogulcancelik/herdr/9a4ce5e13c1d4622ca63c2947d0eaa018ec35715";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # herdr-tiny-fingers — tmux-fingers-style inline copy hints
    herdr-tiny-fingers = {
      url = "github:hotchpotch/herdr-tiny-fingers";
      flake = false;
    };

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
    homebrew-schpet-tap = {
      url = "github:schpet/homebrew-tap";
      flake = false;
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "brew-src";
    };
    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private config
    nix-config-private = {
      url = "git+ssh://git@ssh.github.com/tanordheim/nix-config-private.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { ... }@inputs:
    let
      libExtended = inputs.nixpkgs.lib.extend (
        final: prev: {
          mkPlatformImport = import ./lib/mkPlatformImport.nix;
        }
      );
    in
    {
      darwinConfigurations.lyng = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          isDarwin = true;
          lib = libExtended;
        };
        modules = [ ./hosts/lyng/default.nix ];
      };
      nixosConfigurations.hsrv = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          isDarwin = false;
          lib = libExtended;
        };
        modules = [ ./hosts/hsrv/default.nix ];
      };
      nixosConfigurations.harahorn = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          isDarwin = false;
          lib = libExtended;
        };
        modules = [ ./hosts/harahorn/default.nix ];
      };
    };
}
