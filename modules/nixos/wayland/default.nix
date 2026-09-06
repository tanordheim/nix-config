{ pkgs, ... }:
{
  imports = [ ../swaync ];

  programs.dconf.enable = true;

  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.brightnessctl
          pkgs.hyprpolkitagent
          pkgs.libnotify
          pkgs.networkmanagerapplet
          pkgs.pavucontrol
          pkgs.playerctl
          pkgs.slurp
          pkgs.wl-clipboard
          pkgs.xdg-utils
        ];

        systemd.user.services.hyprpolkitagent = {
          Unit = {
            Description = "Hyprland Polkit Authentication Agent";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };
          Service = {
            ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
            Slice = "session.slice";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      }
    )
  ];
}
