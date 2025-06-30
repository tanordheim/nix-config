{
  pkgs,
  config,
  hyprsunset,
  ...
}:
{
  home-manager.users.${config.username}.services.hyprsunset = {
    enable = true;
    package = hyprsunset.packages.${pkgs.system}.default;
    transitions = {
      sunrise = {
        calendar = "*-*-* 7:00:00";
        requests = [
          [ "temperature 6500" ]
          [ "identity" ]
        ];
      };

      sunset = {
        calendar = "*-*-* 20:00:00";
        requests = [
          [ "temperature 2800" ]
        ];
      };
    };
  };
}
