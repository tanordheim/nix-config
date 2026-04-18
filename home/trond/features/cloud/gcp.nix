{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.gcp;

  gcloud = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];

  loginConfigJson =
    audience:
    builtins.toJSON {
      type = "external_account_authorized_user_login_config";
      inherit audience;
      auth_url = "https://auth.cloud.google/authorize";
      token_url = "https://sts.googleapis.com/v1/oauthtoken";
      token_info_url = "https://sts.googleapis.com/v1/introspect";
    };

  mkConfigFile =
    name: conf:
    let
      isWif = conf.audience != null;
      loginConfigPath = "${config.xdg.configHome}/gcloud/configurations/login_config_${name}.json";
      iniContent =
        if isWif then
          ''
            [auth]
            login_config_file = ${loginConfigPath}
          ''
        else
          ''
            [core]
            account = ${conf.account}
          '';
    in
    iniContent;

  configFiles = lib.mapAttrs' (
    name: conf:
    nameValuePair "gcloud/configurations/config_${name}" {
      text = mkConfigFile name conf;
    }
  ) cfg.configurations;

  loginConfigFiles = lib.filterAttrs (_: conf: conf.audience != null) cfg.configurations;

  loginFiles = lib.mapAttrs' (
    name: conf:
    nameValuePair "gcloud/configurations/login_config_${name}.json" {
      text = loginConfigJson conf.audience;
    }
  ) loginConfigFiles;

in
{
  options.gcp.configurations = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          audience = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          account = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      }
    );
    default = { };
  };

  config = {
    home.packages = [ gcloud ];
    xdg.configFile = configFiles // loginFiles;
  };
}
