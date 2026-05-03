{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./swaync.nix
    ./waybar.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd '${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop'";
      user = "greeter";
    };
  };

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

  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brightnessctl
          hyprland-qtutils
          hyprlauncher
          hyprpolkitagent
          libnotify
          networkmanagerapplet
          pavucontrol
          playerctl
          wl-clipboard
          xdg-utils
        ];

        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
          configPackages = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
          ];
          xdgOpenUsePortal = true;
        };
      }
    )
  ];
}
