{
  flake.modules.homeManager.java-dev =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.java-dev.enable {
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
      };
    };

  flake.modules.darwin.java-dev = { lib, ... }: { };
  flake.modules.nixos.java-dev = { lib, ... }: { };
}
