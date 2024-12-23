{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "run,drun,window";
      drun-display-format = "{icon} {name}";
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
  };
}
