{
  config,
  pkgs,
  lib,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.trond = {
    name = "trond";
    description = "Trond Nordheim";
    home = if pkgs.stdenv.isDarwin then "/Users/trond" else "/home/trond";
    shell = pkgs.zsh;
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ ifTheyExist [ "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG70eJKWOrmTNDfBWLc8+EeniRAOvgfV6bSUfSvkLN4NWc/bWVNlIAiLU24Nievcb8nxgkBLyDcY8ireeCktfMUSmZTr3Zfr8Umd/4DgvoRBQEwLPJGplIqCrzCjuxNxZSRmZnkbsptf0lEFRYgn/9InhCC8ZSk7I4pR0RvPFvw4wjRSe9SBOR5n0ig79D03r31koPwpiDBl0QHUpfnvIg5BpQ9pCNse6Hz1dhjuupE9M0wStUiyPS25fXJjwLDNvXAA54utImivHWa2CAHsY2mmyymwchYq3nqaC6NsRNsNGewQW+DKF9/Xlc0HPKbYoMMM0hQ9uxC6LoOY496MTX"
    ];
  };

  home-manager.users.trond = {
    imports = [ ../../../home/trond/${config.networking.hostName}.nix ];
    home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/trond" else "/home/trond";
    xdg = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      mimeApps.enable = true;
    };
  };
}
