{ config, pkgs, ... }:
let
  avante-nvim-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "avante.nvim";
    version = "2025-02-28";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "yetone";
      repo = "avante.nvim";
      rev = "814bba5ef2207223330721f6a1fb24ac2ae74596";
      hash = "sha256-+ve7Stk47hWKWSynpUlCO/qk9ikisJ5Z9jap9B37PC0=";
    };
  };
  img-clip-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "img-clip.nvim";
    version = "0.6.0";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "HakonHarnes";
      repo = "img-clip.nvim";
      rev = "v0.6.0";
      hash = "sha256-CBZVQ7gTDAONfHrSJEUL4mBjjxj8eeV2KCuZIA/USv8=";
    };
  };
in
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.avante = {
      enable = true;
      package = avante-nvim-plugin;
      settings = {
        provider = "claude";
        claude = {
          endpoint = "https://api.anthropic.com";
          model = "claude-3-7-sonnet-20250219";
          temperature = 0;
          max_tokens = 4096;
        };
        openai = {
          endpoint = "https://api.openai.com/v1";
          model = "gpt-4o";
          timeout = 30000;
          temperature = 0;
          max_tokens = 4096;
        };
      };
    };
    extraPlugins = [ img-clip-plugin ];
  };
}
