{
  flake.modules.darwin.stylix =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.stylix.enable {
        stylix = {
          enable = true;
          image = ../../wallpapers/themed/catppuccin/mocha/catppuccin-mocha-kurzgesagt-galaxy3.png;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

          fonts = {
            serif = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Serif";
            };
            sansSerif = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Sans";
            };
            monospace = {
              package = pkgs.nerd-fonts.iosevka-term;
              name = "Iosevka Term Medium";
            };
            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
            sizes = {
              applications = 13;
              popups = 13;
              terminal = 15;
            };
          };

          opacity.terminal = 0.95;
        };

        homebrew.casks = [ "desktoppr" ];
      };
    };

  flake.modules.nixos.stylix =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.stylix.enable {
        stylix = {
          enable = true;
          image = ../../wallpapers/themed/catppuccin/mocha/catppuccin-mocha-kurzgesagt-galaxy3.png;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

          fonts = {
            serif = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Serif";
            };
            sansSerif = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Sans";
            };
            monospace = {
              package = pkgs.nerd-fonts.iosevka-term;
              name = "Iosevka Term Medium";
            };
            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
            sizes = {
              applications = 13;
              popups = 13;
              terminal = lib.mkDefault 11;
            };
          };

          opacity.terminal = 0.95;
        };
      };
    };

  flake.modules.homeManager.stylix =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.stylix.enable {
        gtk.gtk4.theme = null;

        launchd.agents.stylixwallpaper = lib.mkIf pkgs.stdenv.isDarwin {
          enable = true;
          config = {
            Label = "set-stylix-wallpaper";
            ProgramArguments = [
              "/usr/local/bin/desktoppr"
              (toString config.stylix.image)
            ];
            RunAtLoad = true;
            StandardOutPath = "/tmp/set-stylix-wallpaper.log";
            StandardErrorPath = "/tmp/set-stylix-wallpaper.error.log";
          };
        };
      };
    };
}
