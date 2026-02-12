{
  lib,
  pkgs,
  config,
  ...
}:
let
  versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.rider.version;

  vmOptionsFile =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/JetBrains/Rider${versionMajorMinor}/rider.vmoptions"
    else
      ".config/JetBrains/Rider${versionMajorMinor}/rider64.vmoptions";

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
    packages = [ pkgs.bleeding.jetbrains.rider ];
    file = {
      "${vmOptionsFile}".text = vmOptionsContent;
    };
  };

  jetbrains.ideavimConfigs.rider = ''
    " solution-wide error navigation
    nnoremap [D :action ReSharperGotoPrevErrorInSolution<CR>
    nnoremap ]D :action ReSharperGotoNextErrorInSolution<CR>

    " building and testing
    nnoremap <leader>B :action BuildSolutionAction<CR>
    nnoremap <leader>tt :action RiderUnitTestRunContextAction<CR>
    nnoremap <leader>ta :action RiderUnitTestRunClassAction<CR>
    nnoremap <leader>tl :action RiderUnitTestRepeatPreviousRunAction<CR>
  '';
}
