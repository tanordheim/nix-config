{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        systemd.user.services.swaybg = {
          Unit = {
            Description = "Niri wallpaper";
            PartOf = [ "niri.service" ];
            After = [ "niri.service" ];
            Requisite = [ "niri.service" ];
          };
          Service = {
            ExecStart = "${lib.getExe pkgs.swaybg} --image ${config.stylix.image} --mode ${config.stylix.imageScalingMode}";
            Restart = "on-failure";
            Slice = "session.slice";
          };
          Install.WantedBy = [ "niri.service" ];
        };
      }
    )
  ];
}
