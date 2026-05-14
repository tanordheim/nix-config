{ claudeManagedSettings, ... }:
{
  environment.etc."claude-code/managed-settings.json".text = builtins.toJSON (
    claudeManagedSettings
    // {
      preferredNotifChannel = "notifications_disabled";
    }
  );
}
