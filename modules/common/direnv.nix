{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
