{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.chromium = {
    enable = true;
  };
  # environment.systemPackages = with pkgs; [
  #   chromium
  # ];
}
