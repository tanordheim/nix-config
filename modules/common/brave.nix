{
  pkgs,
  config,
  ...
}:
let
  downloadDirectory =
    if pkgs.stdenv.isDarwin then
      "/Users/${config.username}/Downloads"
    else
      "/home/${config.username}/downloads";

in
{
  # see brave://policy/
  environment.etc."brave/policies/managed/default.json".text = builtins.toJSON {
    BraveAIChatEnabled = false;
    BraveRewardsDisabled = true;
    BraveVPNDisabled = true;
    BraveWalletDisabled = true;
    DownloadDirectory = downloadDirectory;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Google";
    DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?output=chrome&q={searchTerms}";
  };
}
