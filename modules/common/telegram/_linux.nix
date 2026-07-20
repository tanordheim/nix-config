{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;
      in
      {
        home.packages = [ pkgs.telegram-desktop ];

        xdg.configFile."telegram/stylix.tdesktop-palette".text = ''
          windowBg: ${c.base00};
          windowFg: ${c.base05};
          windowBgOver: ${c.base01};
          windowBgRipple: ${c.base02};
          windowSubTextFg: ${c.base03};
          windowSubTextFgOver: ${c.base04};
          windowBoldFg: ${c.base06};
          windowBoldFgOver: ${c.base07};
          windowBgActive: ${c.base0D};
          windowFgActive: ${c.base00};
          windowActiveTextFg: ${c.base0D};
          activeButtonBgOver: ${c.base0D};
          activeButtonBgRipple: ${c.base0C};
          activeLineFg: ${c.base0D};
          activeLineFgError: ${c.base08};
          lightButtonBgOver: ${c.base01};
          lightButtonBgRipple: ${c.base02};
          menuIconFg: ${c.base04};
          menuIconFgOver: ${c.base05};
          placeholderFgActive: ${c.base03};
          inputBorderFg: ${c.base02};
          filterInputBorderFg: ${c.base0D};
          titleFg: ${c.base04};
          titleFgActive: ${c.base05};
          boxTextFgGood: ${c.base0B};
          boxTextFgError: ${c.base08};
          dialogsBgActive: ${c.base0D};
          dialogsUnreadBgMuted: ${c.base03};
          emojiPanCategories: ${c.base01};
          msgInBgSelected: ${c.base02};
          msgOutBg: ${c.base02};
          msgOutBgSelected: ${c.base03};
          msgSelectOverlay: ${c.base0D}4c;
          msgStickerOverlay: ${c.base0D}7f;
          msgOutServiceFg: ${c.base0D};
          msgOutServiceFgSelected: ${c.base0C};
          msgInShadow: ${c.base03}29;
          msgInShadowSelected: ${c.base03}29;
          msgOutShadow: ${c.base03}29;
          msgOutShadowSelected: ${c.base03}29;
          msgInDateFg: ${c.base03};
          msgInDateFgSelected: ${c.base04};
          msgOutDateFg: ${c.base03};
          msgOutDateFgSelected: ${c.base04};
          msgServiceBg: ${c.base05}7f;
          msgServiceBgSelected: ${c.base0E}7f;
          historyOutIconFg: ${c.base0B};
          historyOutIconFgSelected: ${c.base0C};
          msgWaveformInActiveSelected: ${c.base0D};
          msgWaveformInInactive: ${c.base02};
          msgWaveformInInactiveSelected: ${c.base02};
          msgWaveformOutActive: ${c.base0B};
          msgWaveformOutActiveSelected: ${c.base0C};
          msgWaveformOutInactive: ${c.base03};
          msgWaveformOutInactiveSelected: ${c.base03};
          historyPeer1NameFg: ${c.base08};
          historyPeer1UserpicBg: ${c.base08};
          historyPeer1UserpicBg2: ${c.base08};
          historyPeer2NameFg: ${c.base0B};
          historyPeer2UserpicBg: ${c.base0B};
          historyPeer2UserpicBg2: ${c.base0B};
          historyPeer3NameFg: ${c.base0A};
          historyPeer3UserpicBg: ${c.base0A};
          historyPeer3UserpicBg2: ${c.base0A};
          historyPeer4NameFg: ${c.base0D};
          historyPeer4UserpicBg: ${c.base0D};
          historyPeer4UserpicBg2: ${c.base0D};
          historyPeer5NameFg: ${c.base0E};
          historyPeer5UserpicBg: ${c.base0E};
          historyPeer5UserpicBg2: ${c.base0E};
          historyPeer6NameFg: ${c.base0F};
          historyPeer6UserpicBg: ${c.base0F};
          historyPeer6UserpicBg2: ${c.base0F};
          historyPeer7NameFg: ${c.base0C};
          historyPeer7UserpicBg: ${c.base0C};
          historyPeer7UserpicBg2: ${c.base0C};
          historyPeer8NameFg: ${c.base09};
          historyPeer8UserpicBg: ${c.base09};
          historyPeer8UserpicBg2: ${c.base09};
          msgFile1Bg: ${c.base0D};
          msgFile1BgDark: ${c.base0D};
          msgFile1BgOver: ${c.base0D};
          msgFile1BgSelected: ${c.base0D};
          msgFile2Bg: ${c.base0B};
          msgFile2BgDark: ${c.base0B};
          msgFile2BgOver: ${c.base0B};
          msgFile2BgSelected: ${c.base0B};
          msgFile3Bg: ${c.base08};
          msgFile3BgDark: ${c.base08};
          msgFile3BgOver: ${c.base08};
          msgFile3BgSelected: ${c.base08};
          msgFile4Bg: ${c.base0A};
          msgFile4BgDark: ${c.base0A};
          msgFile4BgOver: ${c.base0A};
          msgFile4BgSelected: ${c.base0A};
        '';
      }
    )
  ];
}
