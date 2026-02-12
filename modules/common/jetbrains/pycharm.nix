{
  lib,
  pkgs,
  config,
  ...
}:
let
  versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.pycharm.version;

  vmOptionsFile =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/JetBrains/Pycharm${versionMajorMinor}/pycharm.vmoptions"
    else
      ".config/JetBrains/Pycharm${versionMajorMinor}/pycharm.vmoptions";

  vmOptionsContent =
    if pkgs.stdenv.isDarwin then
      ''
        -Xms1g
        -Xmx2g
      ''
    else
      ''
        -Xms1g
        -Xmx2g
        -Dawt.toolkit.name=WLToolkit
      '';
in
{
  home-manager.users.${config.username}.home = {
    packages = [ pkgs.bleeding.jetbrains.pycharm ];
    file = {
      "${vmOptionsFile}".text = vmOptionsContent;
    };
  };

  jetbrains.ideavimConfigs.pycharm = ''
    " testing
    nnoremap <leader>tt :action ContextRun<CR>
    nnoremap <leader>ta :action RunClass<CR>
    nnoremap <leader>tl :action RerunTests<CR>
  '';
}
