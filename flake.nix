{
  description = "NixOS and nix-darwin config for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-custom.url = "github:tanordheim/nixpkgs/custom-patches";
    nixpkgs-swift.url = "github:NixOS/nixpkgs?ref=70801e06d9730c4f1704fbd3bbf5b8e11c03a2a7";

    # flake-parts + import-tree (dendritic)
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

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

    # Aurral — music discovery/request manager for Lidarr
    aurral-src = {
      url = "github:lklynet/aurral/v1.50.1";
      flake = false;
    };

    # Stylix system wide color scheming/styling
    stylix.url = "github:danth/stylix";

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
    homebrew-telepresence = {
      url = "github:telepresenceio/homebrew-telepresence";
      flake = false;
    };
    homebrew-schpet-tap = {
      url = "github:schpet/homebrew-tap";
      flake = false;
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
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
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [ (inputs.import-tree ./modules) ];
    };
}
