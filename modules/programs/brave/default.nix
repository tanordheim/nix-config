{
  lib,
  isDarwin,
  isLinux,
  ...
}:
{
  imports = [ ] ++ lib.optional isDarwin ./_darwin.nix ++ lib.optional isLinux ./_nixos.nix;

  # see brave://policy/
  environment.etc."brave/policies/managed/default.json".text = builtins.toJSON {
    BraveAIChatEnabled = false;
    BraveRewardsDisabled = true;
    BraveVPNDisabled = true;
    BraveWalletDisabled = true;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Google";
    DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?output=chrome&q={searchTerms}";
  };
}
