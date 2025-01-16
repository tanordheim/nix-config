{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.treesitter = {
    enable = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      c
      css
      diff
      go
      gomod
      gosum
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
      proto
      python
      query
      rasi
      terraform
      vim
      vimdoc
      yaml
    ];
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
