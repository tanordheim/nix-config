{
  flake.modules.homeManager.vscode =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.vscode.enable {
        programs.vscode = {
          enable = true;
          profiles.default.extensions = with pkgs.vscode-extensions; [
            vscodevim.vim
          ];
        };
      };
    };
}
