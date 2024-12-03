{ config, lib, isDarwin, ... }:
let
  cfg = config.d;
  mkString = default:
    with lib; mkOption {
      inherit default;
      type = types.str;
    };
in
{
  options.d = {
    # Used for backwards compatibility, please read the changelog before changing.
    stateVersion = mkString "24.11";

    user = {
      name = mkString "trond";
      fullName = mkString "Trond Nordheim";
      ssh.key = mkString "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG70eJKWOrmTNDfBWLc8+EeniRAOvgfV6bSUfSvkLN4NWc/bWVNlIAiLU24Nievcb8nxgkBLyDcY8ireeCktfMUSmZTr3Zfr8Umd/4DgvoRBQEwLPJGplIqCrzCjuxNxZSRmZnkbsptf0lEFRYgn/9InhCC8ZSk7I4pR0RvPFvw4wjRSe9SBOR5n0ig79D03r31koPwpiDBl0QHUpfnvIg5BpQ9pCNse6Hz1dhjuupE9M0wStUiyPS25fXJjwLDNvXAA54utImivHWa2CAHsY2mmyymwchYq3nqaC6NsRNsNGewQW+DKF9/Xlc0HPKbYoMMM0hQ9uxC6LoOY496MTX";
    };

    git = {
      email = mkString "trond@nordheim.io";
      githubUsername = mkString "tanordheim";
    };
  };
}
