{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      "restic/password" = {
        sopsFile = ../../secrets/harahorn.yaml;
      };
      "telegram/bot_token" = {
        sopsFile = ../../secrets/common.yaml;
      };
      "telegram/chat_id" = {
        sopsFile = ../../secrets/common.yaml;
      };
    };
  };
}
