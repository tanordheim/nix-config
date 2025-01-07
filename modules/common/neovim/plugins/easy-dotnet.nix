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

in
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = [
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
