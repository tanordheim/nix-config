{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  imports = lib.optionals isDarwin [ ./_darwin.nix ];
}
