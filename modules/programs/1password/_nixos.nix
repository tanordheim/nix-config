{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui
  ];

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      brave
    '';
    mode = "0755";
  };
}
