{
  flake.modules.homeManager._1password =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features._1password.enable (
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
      );
    };

  flake.modules.darwin._1password =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features._1password.enable {
        homebrew.casks = [
          "1password"
          "1password-cli"
        ];
      };
    };

  flake.modules.nixos._1password =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features._1password.enable {
        programs._1password.enable = true;
        programs._1password-gui = {
          enable = true;
          package = pkgs._1password-gui.overrideAttrs (oldAttrs: {
            postInstall = ''
              ${oldAttrs.postInstall or ""}
              substituteInPlace $out/share/applications/1password.desktop \
                --replace "Exec=1password %U" 'Exec=1password --js-flags="--no-decommit-pooled-pages" %U'
            '';
          });
        };

        environment.etc."1password/custom_allowed_browsers" = {
          text = ''
            brave
          '';
          mode = "0755";
        };
      };
    };
}
