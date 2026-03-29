{ config, ... }:
{
  home-manager.users.${config.username}.home.file.".claude/skills".source = ./skills;
}
