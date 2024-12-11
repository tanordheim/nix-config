{ pkgs, ... }:
let
  toJSON = (pkgs.formats.json { }).generate;

in
{
  my.user.home.file = {
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
}
