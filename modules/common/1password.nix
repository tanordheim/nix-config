{ pkgs, config, ... }:
let
  ssh = {
    agent =
      if pkgs.stdenv.isDarwin then
        "/Users/${config.username}/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      else
        "/home/${config.username}/.1password/agent.sock";
    sign =
      if pkgs.stdenv.isDarwin then
        "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
      else
        "${pkgs._1password-gui}/share/1password/op-ssh-sign";
  };
in
{
  home-manager.users.${config.username} = {
    home.sessionVariables = {
      SSH_AUTH_SOCK = ssh.agent;
    };
    programs.ssh.extraConfig = ''
      IdentityAgent ${ssh.agent}
    '';
    programs.git.extraConfig.gpg = {
      format = "ssh";
      ssh.program = ssh.sign;
    };
  };
}
