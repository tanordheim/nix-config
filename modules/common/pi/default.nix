{
  inputs,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [ pkgs.pi-coding-agent ];

        home.file.".pi/agent/extensions/herdr-agent-state.ts".source =
          "${inputs.herdr}/src/integration/assets/pi/herdr-agent-state.ts";
      }
    )
  ];
}
