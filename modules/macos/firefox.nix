{
  pkgs,
  config,
  ...
}:
{
  homebrew.casks = [
    "firefox"
  ];

  home-manager.users.${config.username}.home = {
    file = {
      "Library/Application Support/Firefox/policies/policies.json".text = builtins.toJSON {
        DisableTelemetry = true;
        PasswordManagerEnabled = false;
      };
    };
  };
}
