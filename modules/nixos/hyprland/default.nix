{ pkgs, ... }:
let
  hyprlandSession = pkgs.writeShellScript "hyprland-session" ''
    export PATH="${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.hyprland}/bin:$PATH"

    LOG_DIR="$HOME/.local/state/hyprland/sessions"
    SESSION_LOG="$LOG_DIR/$(date +%Y%m%d-%H%M%S).log"
    mkdir -p "$LOG_DIR"

    ls -1t "$LOG_DIR"/*.log 2>/dev/null | tail -n +11 | xargs -r rm -f

    WRAPPER_PID=$$

    (
      for _ in $(seq 1 30); do
        rt=$(ls "$XDG_RUNTIME_DIR"/hypr/*/hyprland.log 2>/dev/null | head -1)
        if [ -n "$rt" ]; then
          exec tail --pid="$WRAPPER_PID" -F -n +1 "$rt" >> "$SESSION_LOG" 2>/dev/null
        fi
        sleep 1
      done
    ) &

    exec start-hyprland "$@" >> "$SESSION_LOG" 2>&1
  '';
in
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
  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${hyprlandSession}";
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
          configPackages = with pkgs; [ xdg-desktop-portal-hyprland ];
          xdgOpenUsePortal = true;
        };
      }
    )
  ];
}
