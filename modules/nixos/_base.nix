{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../common/_overlays.nix
    ../common/base
    ../common/fonts
    ../common/sudo
    ../common/timezone
    ../common/hm-base
    ../common/zsh
    ../common/git
    ../common/ssh
    ../common/starship
    ../common/eza
    ../common/zoxide
    ../common/direnv
    ../common/shell-aliases
    ../common/build-tools
    ../common/users/trond
    ../common/stylix
  ];

  nix = {
    settings = {
      trusted-users = [ "root" ];
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  boot.kernel.sysctl."kernel.sysrq" = 1;
}
