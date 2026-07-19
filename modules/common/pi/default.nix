{
  inputs,
  ...
}:
{
  home-manager.sharedModules = [
    (
      {
        config,
        pkgs,
        ...
      }:
      let
        c = config.lib.stylix.colors.withHashtag;

        piTheme = {
          "$schema" =
            "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
          name = "stylix";
          colors = {
            accent = c.base0D;
            border = c.base03;
            borderAccent = c.base0D;
            borderMuted = c.base02;
            success = c.base0B;
            error = c.base08;
            warning = c.base0A;
            muted = c.base04;
            dim = c.base03;
            text = c.base05;
            thinkingText = c.base04;

            selectedBg = c.base02;
            userMessageBg = c.base01;
            userMessageText = c.base05;
            customMessageBg = c.base01;
            customMessageText = c.base05;
            customMessageLabel = c.base0E;
            toolPendingBg = c.base01;
            toolSuccessBg = c.base01;
            toolErrorBg = c.base01;
            toolTitle = c.base0D;
            toolOutput = c.base05;

            mdHeading = c.base0E;
            mdLink = c.base0D;
            mdLinkUrl = c.base0C;
            mdCode = c.base0B;
            mdCodeBlock = c.base05;
            mdCodeBlockBorder = c.base03;
            mdQuote = c.base0A;
            mdQuoteBorder = c.base03;
            mdHr = c.base03;
            mdListBullet = c.base0D;

            toolDiffAdded = c.base0B;
            toolDiffRemoved = c.base08;
            toolDiffContext = c.base04;

            syntaxComment = c.base03;
            syntaxKeyword = c.base0E;
            syntaxFunction = c.base0D;
            syntaxVariable = c.base08;
            syntaxString = c.base0B;
            syntaxNumber = c.base09;
            syntaxType = c.base0A;
            syntaxOperator = c.base0C;
            syntaxPunctuation = c.base05;

            thinkingOff = c.base03;
            thinkingMinimal = c.base04;
            thinkingLow = c.base0C;
            thinkingMedium = c.base0D;
            thinkingHigh = c.base0E;
            thinkingXhigh = c.base09;
            thinkingMax = c.base08;

            bashMode = c.base09;
          };
        };
      in
      {
        home.packages = [ pkgs.pi-coding-agent ];

        home.file = {
          ".pi/agent/extensions/herdr-agent-state.ts".source =
            "${inputs.herdr}/src/integration/assets/pi/herdr-agent-state.ts";
          ".pi/agent/themes/stylix.json".text = builtins.toJSON piTheme;
        };
      }
    )
  ];
}
