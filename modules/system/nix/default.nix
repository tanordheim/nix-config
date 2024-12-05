{ config, lib, pkgs, isDarwin, ... }:
{
  nix = {
    settings = {
      trusted-users = [ "root" config.d.user.name ];
      experimental-features = "nix-command flakes";
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;
  };

  imports = lib.optionals isDarwin [ ./_darwin.nix ];
}

