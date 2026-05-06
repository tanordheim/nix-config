{ inputs, ... }:
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

        home.file."houdini21.0/packages/SideFXLabs21.0.json".text = builtins.toJSON {
          hpath = [
            "$SIDEFXLABS"
            { "houdini_os == 'linux'" = "$SIDEFXLABS/platform_specific/linux"; }
          ];
          load_package_once = true;
          enable = "houdini_version >= '21.0' and houdini_version < '21.5'";
          version = "21.0";
          env = [ { SIDEFXLABS = "${inputs.sidefx-labs}"; } ];
        };
      }
    )
  ];
}
