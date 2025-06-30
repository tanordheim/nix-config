{
  description = "NixOS and nix-darwin config for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-custom.url = "github:tanordheim/nixpkgs/custom-patches";

    # Apple silicon support (for NixOS on Mac)
    apple-silicon-support = {
      # temp fix for mesa deprecation, see https://github.com/tpwrules/nixos-apple-silicon/issues/285 and https://github.com/tpwrules/nixos-apple-silicon/pull/284
      # url = "git+file:///home/trond/code/nixos-apple-silicon?ref=mesa-deprecation-fix";
      url = "github:nix-community/nixos-apple-silicon";
      # url = "github:oliverbestmann/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Sherlock app launcher
    sherlock = {
      url = "github:Skxxtz/sherlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hypridle.url = "github:hyprwm/hypridle";
    hyprland.url = "github:hyprwm/hyprland";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprsunset.url = "github:hyprwm/hyprsunset";

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
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private config
    nix-config-private = {
      url = "git+ssh://git@github.com/tanordheim/nix-config-private.git?ref=main";
      # url = "git+file:///home/trond/code/nix-config-private?ref=main";
      # url = "git+file:///Users/trond/code/nix-config-private?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs: {
    darwinConfigurations = {
      harahorn-mac = import ./hosts/harahorn-mac { inherit inputs; };
    };
    nixosConfigurations = {
      harahorn = import ./hosts/harahorn { inherit inputs; };
    };
  };
}
