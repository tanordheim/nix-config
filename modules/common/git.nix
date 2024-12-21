{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    home.packages = with pkgs; [
      gh
      git-lfs
    ];

    programs.git = {
      enable = true;

      userName = config.username;
      userEmail = config.git.email;

      signing = {
        signByDefault = true;
        key = config.user.ssh.key;
      };

      aliases = {
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
        "filter \"lfs\"" = {
          clean = "${pkgs.git-lfs}/bin/git-lfs clean -- %f";
          smudge = "${pkgs.git-lfs}/bin/git-lfs smudge --skip -- %f";
          process = "${pkgs.git-lfs}/bin/git-lfs filter-process --skip";
          required = true;
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
}
