{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-treesitter.withPlugins (
          p: with p; [
            bash
            c
            css
            diff
            helm
            html
            ini
            javascript
            json
            jsonc
            typescript
            lua
            luadoc
            markdown
            markdown_inline
            nix
            query
            terraform
            vim
            vimdoc
            yaml
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
