{
  config,
  ...
}:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ config.username ];
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      brave
    '';
    mode = "0755";
  };
}
