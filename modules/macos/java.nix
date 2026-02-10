{ pkgs, config, ... }:
{
  launchd.user.envVariables = {
    JAVA_HOME = "${pkgs.jdk.home}";
  };

  launchd.agents.setenv-java-home = {
    serviceConfig = {
      Label = "org.nix.setenv-java-home";
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "JAVA_HOME"
        "${pkgs.jdk.home}"
      ];
      RunAtLoad = true;
      StandardOutPath = "/dev/null";
      StandardErrorPath = "/dev/null";
    };
  };
}
