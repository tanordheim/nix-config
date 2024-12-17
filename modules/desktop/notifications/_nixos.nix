{ pkgs, ... }:
{
  my.user.services.dunst = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      global = {
        monitor = 0;
        width = 500;
        origin = "top right";
        offset = "20x20";
        font = "JetBrainsMono Nerd Font, Medium 12";
      };
    };
  };

  # [global]
  # monitor = 0
  # width = 300
  # offset = 10x10
  # font = JetBrains Mono, Monospace 10
  # frame_color = "#89b4fa"
  # separator_color= frame
  #
  # [urgency_low]
  # background = "#1e1e2e"
  # foreground = "#cdd6f4"
  #
  # [urgency_normal]
  # background = "#1e1e2e"
  # foreground = "#cdd6f4"
  #
  # [urgency_critical]
  # background = "#1e1e2e"
  # foreground = "#cdd6f4"
  # frame_color = "#fab387"

  # my.user.programs.rofi = {
  #   enable = true;
  #   package = pkgs.rofi-wayland;
  #   terminal = "${pkgs.alacritty}/bin/alacritty";
  #   extraConfig = {
  #     modi = "run,drun,window";
  #     drun-display-format = "{icon} {name}";
  #     hide-scrollbar = true;
  #     display-drun = "   Apps ";
  #     display-run = "   Run ";
  #     display-window = " 󰕰  Window";
  #     display-Network = " 󰤨  Network";
  #     sidebar-mode = true;
  #   };
  # };
}
