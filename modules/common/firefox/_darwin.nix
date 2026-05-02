{
  homebrew.casks = [ "firefox" ];

  home-manager.sharedModules = [
    {
      home.file."Library/Application Support/Firefox/policies/policies.json".text = builtins.toJSON {
        DisableTelemetry = true;
        PasswordManagerEnabled = false;
      };
    }
  ];
}
