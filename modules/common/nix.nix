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
      stable = import nixpkgs-stable { inherit (prev) system; };
    })
    (_final: prev: {
      vimPlugins = prev.vimPlugins // {
        snacks-vim =
          let
            version = "v2.20.0";
          in
          (prev.vimUtils.buildVimPlugin {
            pname = "snacks.nvim";
            inherit version;

            src = prev.fetchFromGitHub {
              owner = "folke";
              repo = "snacks.nvim";
              rev = "76a5dcfb318d623022dada44c66453d9cb9a6eaa";
              hash = "sha256-DLbXRDBKGxe3JcgrqNp4FPJq/yKZZcGdOR6I9b3+YCo=";
            };

            doCheck = false;

            meta = {
              description = "🍿 A collection of QoL plugins for Neovim";
              homepage = "https://github.com/folke/snacks.nvim";
            };
          });
      };
    })
  ];
}
