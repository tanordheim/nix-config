{
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
let
  ssh = {
    agent =
      if isDarwin then
        "${config.my.osUser.home}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      else
        "~/.1password/agent.sock";
    sign =
      if isDarwin then
        "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
      else
        "${pkgs._1password-gui}/share/1password/op-ssh-sign";
  };
in
{
  my.user.home.sessionVariables = {
    SSH_AUTH_SOCK = ssh.agent;
  };
  my.user = {
    programs.ssh.extraConfig = ''
      IdentityAgent "${ssh.agent}"
    '';
    programs.git.extraConfig.gpg = {
      format = "ssh";
      ssh.program = ssh.sign;
    };
  };

  imports = lib.optionals isDarwin [ ./_darwin.nix ];
}
