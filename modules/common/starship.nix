{ config, ... }:
{
  home-manager.users.${config.username}.programs.starship = {
    enable = true;
    settings = {
      docker_context = {
        disabled = true;
      };
    };
  };
}
