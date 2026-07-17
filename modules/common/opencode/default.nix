{
  inputs,
  ...
}:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        baseMcpServers = {
        };

        opencodeConfig = {
          "$schema" = "https://opencode.ai/config.json";
          autoupdate = false;
          mcp = config.opencode.mcpServers // baseMcpServers;
        }
        // lib.optionalAttrs (config.opencode.providers != { }) {
          provider = config.opencode.providers;
        };

        c = config.lib.stylix.colors.withHashtag;

        opencodeTheme = {
          theme = {
            primary = c.base0D;
            secondary = c.base0E;
            accent = c.base0C;
            error = c.base08;
            warning = c.base0A;
            success = c.base0B;
            info = c.base0D;
            text = c.base05;
            textMuted = c.base04;
            background = c.base00;
            backgroundPanel = c.base01;
            backgroundElement = c.base02;
            border = c.base03;
            borderActive = c.base0D;
            borderSubtle = c.base02;

            diffAdded = c.base0B;
            diffRemoved = c.base08;
            diffContext = c.base04;
            diffHunkHeader = c.base0C;
            diffHighlightAdded = c.base0B;
            diffHighlightRemoved = c.base08;
            diffLineNumber = c.base03;

            markdownText = c.base05;
            markdownHeading = c.base0E;
            markdownLink = c.base0D;
            markdownLinkText = c.base0C;
            markdownCode = c.base0B;
            markdownBlockQuote = c.base0A;
            markdownEmph = c.base0A;
            markdownStrong = c.base09;
            markdownHorizontalRule = c.base03;
            markdownListItem = c.base0D;
            markdownListEnumeration = c.base0C;
            markdownImage = c.base0D;
            markdownImageText = c.base0C;
            markdownCodeBlock = c.base05;

            syntaxComment = c.base03;
            syntaxKeyword = c.base0E;
            syntaxFunction = c.base0D;
            syntaxVariable = c.base08;
            syntaxString = c.base0B;
            syntaxNumber = c.base09;
            syntaxType = c.base0A;
            syntaxOperator = c.base0C;
            syntaxPunctuation = c.base05;
          };
        };

        opencodeConfigFile = pkgs.writeText "opencode.json" (builtins.toJSON opencodeConfig);

        # WORKAROUND: use upstream flake until nixos-unstable has opencode 1.18,
        # https://github.com/NixOS/nixpkgs/pull/542697 — revert to pkgs.opencode.
        opencodePackage = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

        opencodeWrapper = pkgs.writeShellScriptBin "opencode" ''
          exec env \
            OPENCODE_DISABLE_CLAUDE_CODE=1 \
            OPENCODE_DISABLE_EXTERNAL_SKILLS=1 \
            OPENCODE_CONFIG=${opencodeConfigFile} \
            ${opencodePackage}/bin/opencode "$@"
        '';
      in
      {
        options.opencode.mcpServers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        options.opencode.providers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        config = {
          home.packages = [ opencodeWrapper ];

          home.file = {
            ".config/opencode/themes/stylix.json".text = builtins.toJSON opencodeTheme;
            ".config/opencode/plugins/herdr-agent-state.js".source =
              "${inputs.herdr}/src/integration/assets/opencode/herdr-agent-state.js";
          };
        };
      }
    )
  ];
}
