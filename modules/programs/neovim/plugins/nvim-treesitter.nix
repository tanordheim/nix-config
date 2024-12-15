{ pkgs, ... }:
{
  my.user.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-treesitter.withPlugins (
          p: with p; [
            bash
            c
            css
            diff
            html
            lua
            luadoc
            markdown
            markdown_inline
            nix
            terraform
            query
            vim
            vimdoc
          ]
        );
        type = "lua";
        config = # lua
          ''
            require('nvim-treesitter.configs').setup {
              ensure_installed = {},
              highlight = {
                enable = true,
              },
              indent = {
                enable = true,
              }
            }
          '';
      }
    ];
  };
}
