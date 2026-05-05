{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.houdini ];

        xdg.desktopEntries.houdini = {
          name = "Houdini";
          genericName = "3D Animation";
          comment = "SideFX Houdini";
          exec = "houdini %F";
          icon = "${pkgs.houdini.unwrapped}/houdini_logo.png";
          terminal = false;
          categories = [ "Graphics" "3DGraphics" ];
          mimeType = [ "application/x-houdini" ];
        };
      }
    )
  ];
}
