{ pkgs, config, ... }:
{
  imports = [ ./skills.nix ];
  home-manager.users.${config.username}.home.packages = with pkgs; [
    claude-code
  ];
  homebrew.casks = [
    "claude"
  ];
}
