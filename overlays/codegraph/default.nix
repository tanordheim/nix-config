{ ... }:
final: prev: {
  codegraph = prev.buildNpmPackage rec {
    pname = "codegraph";
    # MANUAL UPDATE CHECK: https://github.com/colbymchenry/codegraph/releases
    version = "1.0.1";

    src = prev.fetchFromGitHub {
      owner = "colbymchenry";
      repo = "codegraph";
      rev = "v${version}";
      hash = "sha256-k4UMQit4/Yqgyuv+x1pZqyInPpBvJ4Qy9Y8Vpgu4FNI=";
    };

    npmDepsHash = "sha256-FdWAmkYKRVnztBF4Va6chOVLdH8DHNfDM2aobCIRsq4=";

    nodejs = prev.nodejs_24;

    meta = {
      description = "Local semantic code-graph MCP server for Claude Code";
      homepage = "https://github.com/colbymchenry/codegraph";
      license = prev.lib.licenses.mit;
      mainProgram = "codegraph";
    };
  };
}
