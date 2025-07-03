{
  pkgs,
  config,
  ...
}:
{
  home-manager.users.${config.username}.services.hyprsunset = {
    enable = true;
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
