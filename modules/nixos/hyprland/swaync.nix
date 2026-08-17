{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;
        f = config.stylix.fonts;
      in
      {
        stylix.targets.swaync.enable = false;

        services.swaync = {
          enable = true;

          style = ''
            * {
              font-family: "${f.sansSerif.name}";
              font-size: ${toString f.sizes.applications}pt;
            }

            .control-center {
              background: ${c.base00};
              border: 1px solid ${c.base02};
              border-radius: 12px;
              color: ${c.base05};
            }

            .widget-title {
              color: ${c.base05};
              margin: 8px;
            }

            .widget-title > button {
              background: ${c.base01};
              border: none;
              border-radius: 8px;
              color: ${c.base05};
            }

            .widget-title > button:hover {
              background: ${c.base02};
            }

            .widget-dnd {
              color: ${c.base05};
              margin: 8px;
            }

            .widget-dnd > switch {
              background: ${c.base01};
              border: 1px solid ${c.base02};
              border-radius: 999px;
            }

            .widget-dnd > switch:checked {
              background: ${c.base0E};
            }

            .widget-dnd > switch slider {
              background: ${c.base05};
              border-radius: 999px;
            }

            .notification-row .notification-background {
              background: transparent;
            }

            .notification {
              background: ${c.base01};
              border: 1px solid ${c.base02};
              border-radius: 8px;
              box-shadow: none;
            }

            .notification.critical {
              border: 1px solid ${c.base08};
            }

            .notification-content {
              background: transparent;
              border: none;
            }

            .notification-group .notification-group-buttons,
            .notification-group .notification-group-headers {
              color: ${c.base05};
            }

            .notification-group.collapsed .notification-row .notification {
              background: ${c.base01};
              border: 1px solid ${c.base02};
              box-shadow: none;
            }

            .summary {
              color: ${c.base05};
            }

            .body {
              color: ${c.base04};
            }

            .time {
              color: ${c.base04};
            }

            .close-button {
              background: transparent;
              border-radius: 8px;
              color: ${c.base04};
            }

            .close-button:hover {
              background: ${c.base02};
              color: ${c.base05};
            }

            .notification-action {
              background: ${c.base02};
              border: none;
              border-radius: 8px;
              color: ${c.base05};
            }

            .notification-action:hover {
              background: ${c.base03};
            }

            progress,
            progressbar,
            trough {
              border: none;
            }

            trough {
              background: ${c.base02};
            }

            progress {
              background: ${c.base0E};
            }

            .widget-mpris .widget-mpris-player {
              background: ${c.base01};
              border: none;
              border-radius: 8px;
              color: ${c.base05};
            }
          '';
        };
      }
    )
  ];
}
