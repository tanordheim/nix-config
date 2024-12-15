{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rofi-wayland
  ];

  my.user.programs.rofi = {
    enable = true;
    catppuccin.enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
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

  # my.user.xdg.configFile = {
  #   "rofi/config.rasi" = {
  #     # TODO
  #     # icon-theme: "Oranchelo";
  #     # show-icons: true;
  #     text = ''
  #       configuration{
  #         modi: "run,drun,window";
  #         terminal: "${pkgs.alacritty}/bin/alacritty";
  #         drun-display-format: "{icon} {name}";
  #         location: 0;
  #         disable-history: false;
  #         hide-scrollbar: true;
  #         display-drun: "   Apps ";
  #         display-run: "   Run ";
  #         display-window: " 󰕰  Window";
  #         display-Network: " 󰤨  Network";
  #         sidebar-mode: true;
  #       }
  #     '';
  #   };
  # };
}
