{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  imports = [ (lib.mkPlatformImport ./. isDarwin) ];

  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        ssh = {
          agent =
            if pkgs.stdenv.isDarwin then
              "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
            else
              "${config.home.homeDirectory}/.1password/agent.sock";
          sign =
            if pkgs.stdenv.isDarwin then
              "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
            else
              "${pkgs._1password-gui}/share/1password/op-ssh-sign";
        };
      in
      {
        home.sessionVariables = {
          SSH_AUTH_SOCK = ssh.agent;
        };
        programs.ssh.extraConfig = ''
          IdentityAgent "${ssh.agent}"
        '';
        programs.git.settings = {
          ssh.program = ssh.sign;
        };
      }
    )
  ];
}
