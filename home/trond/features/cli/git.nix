{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gh
    git-filter-repo
    gnupg
    lazygit
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;

    signing = {
      signByDefault = true;
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG70eJKWOrmTNDfBWLc8+EeniRAOvgfV6bSUfSvkLN4NWc/bWVNlIAiLU24Nievcb8nxgkBLyDcY8ireeCktfMUSmZTr3Zfr8Umd/4DgvoRBQEwLPJGplIqCrzCjuxNxZSRmZnkbsptf0lEFRYgn/9InhCC8ZSk7I4pR0RvPFvw4wjRSe9SBOR5n0ig79D03r31koPwpiDBl0QHUpfnvIg5BpQ9pCNse6Hz1dhjuupE9M0wStUiyPS25fXJjwLDNvXAA54utImivHWa2CAHsY2mmyymwchYq3nqaC6NsRNsNGewQW+DKF9/Xlc0HPKbYoMMM0hQ9uxC6LoOY496MTX";
      format = "ssh";
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
        name = "trond";
        email = "trond@nordheim.io";
      };

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
      github.user = "tanordheim";
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
}
