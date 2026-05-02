{
  config,
  lib,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.trond = {
    home = "/home/trond";
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ] ++ ifTheyExist [ "docker" "gamemode" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG70eJKWOrmTNDfBWLc8+EeniRAOvgfV6bSUfSvkLN4NWc/bWVNlIAiLU24Nievcb8nxgkBLyDcY8ireeCktfMUSmZTr3Zfr8Umd/4DgvoRBQEwLPJGplIqCrzCjuxNxZSRmZnkbsptf0lEFRYgn/9InhCC8ZSk7I4pR0RvPFvw4wjRSe9SBOR5n0ig79D03r31koPwpiDBl0QHUpfnvIg5BpQ9pCNse6Hz1dhjuupE9M0wStUiyPS25fXJjwLDNvXAA54utImivHWa2CAHsY2mmyymwchYq3nqaC6NsRNsNGewQW+DKF9/Xlc0HPKbYoMMM0hQ9uxC6LoOY496MTX"
    ];
  };

  home-manager.sharedModules = [
    {
      home.homeDirectory = "/home/trond";
      xdg = {
        enable = true;
        mimeApps.enable = true;
      };
    }
  ];

  programs._1password-gui.polkitPolicyOwners = lib.mkIf config.programs._1password-gui.enable [
    "trond"
  ];

  security.sudo.extraRules = [
    {
      users = [ "trond" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
