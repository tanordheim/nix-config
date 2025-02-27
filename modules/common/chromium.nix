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
  # see chrome://policy/
  environment.etc."chromium/policies/managed/default.json".text = builtins.toJSON {
    DownloadDirectory = downloadDirectory;
  };
  home-manager.users.${config.username}.home.sessionVariables = {
    GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
    GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
  };
}
