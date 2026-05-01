{
  environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
    preferredNotifChannel = "notifications_disabled";
  };
}
