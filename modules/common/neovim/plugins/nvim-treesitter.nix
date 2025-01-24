{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.treesitter = {
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
      diff
      helm
      ini
      javascript
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
}
