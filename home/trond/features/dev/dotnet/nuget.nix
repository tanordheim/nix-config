{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.dotnet;

  dotnet-sdk = pkgs.dotnetCorePackages.sdk_10_0-bin;

  buildNugetConfig =
    nugetSources:
    pkgs.stdenv.mkDerivation {
      name = "nugetConfig";
      phases = [ "installPhase" ];
      buildInputs = [ dotnet-sdk ];
      installPhase =
        let
          toCommand =
            name: params:
            ''${dotnet-sdk}/bin/dotnet nuget add source "${params.url}" --name "${name}" --protocol-version "${builtins.toString (params.protocolVersion)}" --username "${params.username}" --password "${params.password}" --store-password-in-clear-text'';
          commands = lib.concatStringsSep "\n" (lib.mapAttrsToList toCommand nugetSources);
        in
        ''
          mkdir -p "$out"
          export HOME=$TMPDIR
          ${dotnet-sdk}/bin/dotnet nuget remove source nuget.org
          ${commands}
          cp -R $TMPDIR/.nuget $out/
        '';
    };

in
{
  options.dotnet.nugetSources = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          url = mkOption {
            type = types.str;
          };
          protocolVersion = mkOption {
            type = types.ints.between 2 3;
            default = 2;
          };
          username = mkOption {
            type = types.str;
            default = "";
          };
          password = mkOption {
            type = types.str;
            default = "";
          };
        };
      }
    );
    default = { };
  };

  config = {
    dotnet.nugetSources = {
      "nuget.org" = {
        url = "https://api.nuget.org/v3/index.json";
        protocolVersion = 3;
      };
    };
    home.file = {
      ".nuget/NuGet/NuGet.Config".source =
        let
          nugetConfig = buildNugetConfig cfg.nugetSources;
        in
        "${nugetConfig}/.nuget/NuGet/NuGet.Config";
    };
  };
}
