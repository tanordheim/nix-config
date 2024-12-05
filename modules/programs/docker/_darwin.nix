{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    colima
    lima
  ];

  launchd.user.agents."colima.default" = {
    command = "${pkgs.colima}/bin/colima start --foreground --cpu 4 --memory 8";
    serviceConfig = {
      Label = "com.colima.default";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.my.user.xdg.dataHome}/colima/colima.stdout.log";
      StandardErrorPath = "${config.my.user.xdg.dataHome}/colima/colima.stderr.log";
      EnvironmentVariables = {
        COLIMA_HOME = "${config.my.user.xdg.configHome}/colima";
        PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
