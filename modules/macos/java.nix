{ pkgs, ... }:
{
  launchd.user.envVariables = {
    JAVA_HOME = "${pkgs.jdk.home}";
  };
}
