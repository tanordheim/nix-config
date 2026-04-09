{ pkgs, lib, ... }:
{
  programs.java = {
    enable = true;
  };

  launchd.agents.setenv-java-home = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
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
