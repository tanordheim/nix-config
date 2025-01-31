{
  config,
  lib,
  nixvim,
  ...
}:
let
  cfg = config.d;
  mkString =
    default:
    with lib;
    mkOption {
      inherit default;
      type = types.str;
    };
  mkPath =
    default:
    with lib;
    mkOption {
      inherit default;
      type = types.path;
    };

in
{
  imports = [
    ./1password.nix
    ./aws.nix
    ./base-packages.nix
    ./brave.nix
    ./docker.nix
    ./direnv.nix
    ./eza.nix
    ./dotnet
    ./fonts.nix
    ./git.nix
    ./go.nix
    ./jetbrains
    ./kaf.nix
    ./kubectl.nix
    ./neovim
    ./nix.nix
    ./node.nix
    ./python.nix
    ./shell-aliases.nix
    ./signal.nix
    ./ssh.nix
    ./starship.nix
    ./stylix.nix
    ./sudo.nix
    ./telegram.nix
    ./terraform.nix
    ./timezone.nix
    ./wezterm.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  options = {
    username = mkString "trond";
    user = {
      fullName = mkString "Trond Nordheim";
      ssh.key = mkString "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG70eJKWOrmTNDfBWLc8+EeniRAOvgfV6bSUfSvkLN4NWc/bWVNlIAiLU24Nievcb8nxgkBLyDcY8ireeCktfMUSmZTr3Zfr8Umd/4DgvoRBQEwLPJGplIqCrzCjuxNxZSRmZnkbsptf0lEFRYgn/9InhCC8ZSk7I4pR0RvPFvw4wjRSe9SBOR5n0ig79D03r31koPwpiDBl0QHUpfnvIg5BpQ9pCNse6Hz1dhjuupE9M0wStUiyPS25fXJjwLDNvXAA54utImivHWa2CAHsY2mmyymwchYq3nqaC6NsRNsNGewQW+DKF9/Xlc0HPKbYoMMM0hQ9uxC6LoOY496MTX";
      image = mkPath ../media/face.png;
    };
    git = {
      email = mkString "trond@nordheim.io";
      githubUsername = mkString "tanordheim";
    };
  };

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.username} = {
        xdg.enable = true;
        programs.home-manager.enable = true;

        home = {
          stateVersion = "24.11";
        };

        imports = [
          nixvim.homeManagerModules.nixvim
        ];
      };
    };
  };
}
