{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.copilot-lua = {
    enable = true;
    settings = {
      suggestions.enabled = false;
      panel.enabled = false;
    };
  };
}
