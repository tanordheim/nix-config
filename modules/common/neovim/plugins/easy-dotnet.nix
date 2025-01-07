{ pkgs, config, ... }:
let
  easy-dotnet-nvim-git = (
    pkgs.vimUtils.buildVimPlugin {
      name = "easy-dotnet.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "GustavEikaas";
        repo = "easy-dotnet.nvim";
        rev = "b0a1fa6a087925fc716291d3ff910d496d259510";
        hash = "sha256-gvV41ek19KFljE82G0bfP6pTkKqYO4yh2eAUe4asFtw=";
      };
    }
  );
  roslyn-nvim-git = (
    pkgs.vimUtils.buildVimPlugin {
      name = "roslyn.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "seblj";
        repo = "roslyn.nvim";
        rev = "85aca5d48ddf8ada4e010ee9fa4d43c77ebf68c9";
        hash = "sha256-UW0iWGNNWjLIYszKUBYOqoFxbmELX9VVgTj63UJdo4A=";
      };
    }
  );

in
{
  home-manager.users.${config.username}.programs.neovim = {
    extraPackages = with pkgs; [
      roslyn-ls
    ];
    plugins = [
      {
        plugin = roslyn-nvim-git;
        type = "lua";
        config = # lua
          ''
            local roslyn = require('roslyn')
            roslyn.setup()
          '';
      }
      {
        plugin = easy-dotnet-nvim-git;
        type = "lua";
        config = # lua
          ''
            local dotnet = require('easy-dotnet')
            dotnet.setup()
          '';
      }
    ];
  };
}
