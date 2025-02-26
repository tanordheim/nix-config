{ pkgs, config, ... }:
let
  grpc-nvim-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "grpc-nvim";
    version = "2023-01-22";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "hudclark";
      repo = "grpc-nvim";
      rev = "cd235398a9922ae412f59ebeabb0b13957be0d39";
      hash = "sha256-hXf0BsmgOcPtgDfdN0akjtNiL42mTlFX+5C8Dd0qs9s=";
    };
  };
  treesitter-grpc-nvim-grammar = pkgs.tree-sitter.buildGrammar {
    language = "grpc";
    version = "2025-01-19";
    src = pkgs.fetchFromGitHub {
      owner = "antosha417";
      repo = "tree-sitter-grpc-nvim";
      rev = "dcfa497e774cdc0a81430c4c6625c5e7000a2ec6";
      hash = "sha256-tPoRHJvxjqFgQ/lDO5X5EMkP+cvdO8211lIPUhzUJ4Y=";
    };
    meta.homepage = "https://github.com/antosha417/tree-sitter-grpc-nvim";
  };
in
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPlugins = [
      grpc-nvim-plugin
      treesitter-grpc-nvim-grammar
    ];

    plugins.treesitter.grammarPackages = [
      treesitter-grpc-nvim-grammar
    ];
  };
}
