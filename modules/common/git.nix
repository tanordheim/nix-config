{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    home.packages = with pkgs; [
      gh
      lazygit
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;

      signing = {
        signByDefault = true;
        key = config.user.ssh.key;
      };

      settings = {
        alias = {
          st = "status";
          co = "checkout";
          di = "diff";
          dc = "diff --cached";
          amend = "commit --amend";
          aa = "add --all :/";
          b = "branch";
          lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
          pr = "pull --rebase";
          thrust = "!f() { until git push $@; do sleep 0.5; done; }; f";
        };

        user = {
          name = config.username;
          email = config.git.email;
        };

        extraConfig = {
          apply.whitespace = "nowarn";
          branch.autosetupmerge = true;
          color = {
            branch = "auto";
            diff = "auto";
            interactive = "auto";
            status = "auto";
          };
          core = {
            pager = "less -FXRS -x2";
            autocrlf = "input";
            editor = "nvim";
          };
          github.user = config.git.githubUsername;
          init.defaultBranch = "main";
          merge.tool = "vimdiff";
          push.default = "simple";
          rebase.autosquash = true;
          rerere = {
            enabled = true;
            autoupdate = true;
          };
        };
      };

    };
  };
}
