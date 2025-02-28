{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };

      # grammar packages not covered by a language setup under ./languages/
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        css
        devicetree
        diff
        helm
        http
        ini
        javascript
        just
        json
        jsonc
        typescript
        markdown
        markdown_inline
        query
        rasi
        vim
        vimdoc
      ];
    };
    treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "af" = {
            query = "@function.outer";
            desc = "Select outer part of function";
          };
          "if" = {
            query = "@function.inner";
            desc = "Select outer part of function";
          };
          "ac" = {
            query = "@class.outer";
            desc = "Select outer part of class";
          };
          "ic" = {
            query = "@class.inner";
            desc = "Select inner part of class";
          };
        };
      };
    };
  };
}
