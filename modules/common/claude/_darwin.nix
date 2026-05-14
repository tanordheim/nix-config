{
  pkgs,
  lib,
  claudeManagedSettings,
  ...
}:
let
  managedSettings = pkgs.writeText "claude-managed-settings.json" (
    builtins.toJSON claudeManagedSettings
  );
in
{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "setting up Claude Code managed settings..."
    mkdir -p "/Library/Application Support/ClaudeCode"
    ln -sf ${managedSettings} "/Library/Application Support/ClaudeCode/managed-settings.json"
  '';
}
