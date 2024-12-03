{ config, ... }:
{
  my.user = {
    programs.git = {
      enable = true;

      userName = config.d.user.name;
      userEmail = config.d.git.email;

      signing = {
        signByDefault = true;
	key = config.d.user.ssh.key;
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
        github.user = config.d.git.githubUsername;
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
