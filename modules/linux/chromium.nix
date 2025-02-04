{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      # 1Password
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa"
    ];
  };
  # environment.systemPackages = with pkgs; [
  #   chromium
  # ];
}
