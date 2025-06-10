{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.services.hyprsunset = {
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
          [ "temperature 3500" ]
        ];
      };
    };
  };
}
