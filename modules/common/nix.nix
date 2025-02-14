{
  nixpkgs,
  nixpkgs-stable,
  config,
  ...
}:
{
  nix = {
    settings = {
      trusted-users = [
        "root"
        config.username
      ];
      experimental-features = "nix-command flakes";
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # TODO: https://github.com/NixOS/nixpkgs/issues/326335
      "dotnet-sdk-6.0.428"
    ];
  };
  nixpkgs.overlays = [
    (prev: final: {
      # vimPlugins = prev.vimPlugins // {
      #   snacks-vim =
      #     let
      #       version = "2025-02-12";
      #     in
      #     (prev.vimUtils.buildVimPlugin {
      #       pname = "snacks.nvim";
      #       inherit version;
      #
      #       src = prev.fetchFromGitHub {
      #         owner = "folke";
      #         repo = "snacks.nvim";
      #         rev = "1491b543ef1d8a0eb29a6ebc35db4fb808dcb47f";
      #         hash = "sha256-DLbXRDBKGxe3JcgrqNp4FPJq/yKZZcGdOR6I9b3+YCo=";
      #       };
      #
      #       doCheck = false;
      #
      #       meta = {
      #         description = "🍿 A collection of QoL plugins for Neovim";
      #         homepage = "https://github.com/folke/snacks.nvim";
      #       };
      #     });
      # };
      stable = import nixpkgs-stable { inherit (prev) system; };
    })
    (prev: final: {
    })
  ];
}
