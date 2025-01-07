{ pkgs, config, ... }:
let
  easy-dotnet-nvim-git = (
    pkgs.vimUtils.buildVimPlugin {
      name = "easy-dotnet.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "GustavEikaas";
        repo = "easy-dotnet.nvim";
        rev = "b0a1fa6a087925fc716291d3ff910d496d259510";
        hash = "sha256-bPKN+jawWWO4CTd4z6JoJszylrZ/93vWLJRmr7E2n0c=";
      };
    }
  );

in
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = [
      {
        plugin = easy-dotnet-nvim-git;
        type = "lua";
        config = # lua
          '''';
      }
    ];
  };
}
