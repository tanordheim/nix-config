{
  inputs,
  config,
  ...
}:
let
  exaApiKeyFile = config.sops.secrets."pi/exa_api_key".path;
in
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          (pkgs.symlinkJoin {
            name = "pi-coding-agent-wrapped";
            paths = [ pkgs.pi-coding-agent ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/pi \
                --run 'if [ -r ${exaApiKeyFile} ]; then PI_EXA_API_KEY=$(cat ${exaApiKeyFile}); export PI_EXA_API_KEY; fi'
            '';
          })
        ];

        home.file.".pi/agent/extensions/herdr-agent-state.ts".source =
          "${inputs.herdr}/src/integration/assets/pi/herdr-agent-state.ts";
      }
    )
  ];
}
