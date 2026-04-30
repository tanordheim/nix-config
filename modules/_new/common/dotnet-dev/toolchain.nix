{
  home-manager.sharedModules = [
    (
      {
        lib,
        pkgs,
        config,
        ...
      }:
      with lib;
      let
        cfg = config.dotnet;

        dotnet-packages =
          with pkgs;
          with dotnetCorePackages;
          combinePackages [
            sdk_10_0-bin
          ];

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

        toJSON = (pkgs.formats.json { }).generate;
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
          home.packages = [ dotnet-packages ];

          home.sessionPath = [
            "$HOME/.dotnet/tools"
          ];
          home.sessionVariables = {
            DOTNET_ROOT = "${dotnet-packages}/share/dotnet";
          };

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

            "omnisharp.json".source = toJSON "omnisharp.json" {
              RoslynExtensionOptions = {
                enableDecompilationSupport = true;
                enableAnalyzersSupport = true;
                inlayHintsOptions = {
                  enableForParameters = true;
                  forLiteralParameters = true;
                  forIndexerParameters = true;
                  forObjectCreationParameters = true;
                  forOtherParameters = true;
                  suppressForParametersThatDifferOnlyBySuffix = true;
                  suppressForParametersThatMatchMethodIntent = true;
                  suppressForParametersThatMatchArgumentName = true;
                  enableForTypes = true;
                  forImplicitVariableTypes = true;
                  forLambdaParameterTypes = true;
                  forImplicitObjectCreation = true;
                };
              };
            };
          };
        };
      }
    )
  ];
}
