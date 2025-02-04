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
}
