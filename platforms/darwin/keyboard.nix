{ lib, ... }:
{
  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    KeyRepeat = 2;
    InitialKeyRepeat = 25;
  };

  system.activationScripts.extraUserActivation.text =
    let
      hotkeys = [
        32 # mission control
        33 # application windows
        79 # move space left
        81 # move space right
      ];

      disableHotKeyCommands = map (
        key:
        "defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${toString key} '
<dict>
  <key>enabled</key><false/>
  <key>value</key>
  <dict>
    <key>type</key><string>standard</string>
    <key>parameters</key>
    <array>
      <integer>65535</integer>
      <integer>65535</integer>
      <integer>0</integer>
    </array>
  </dict>
</dict>'"
      ) hotkeys;
    in
    ''
      ${lib.concatStringsSep "\n" disableHotKeyCommands}
    '';
}
