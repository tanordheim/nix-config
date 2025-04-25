{ config, ... }:
{
  home-manager.users.${config.username} = {
    home.shellAliases = {
      mkdir = "mkdir -p";
      ".." = "cd ../";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
    };

    programs.zsh.initContent = # zsh
      ''
        # convenience function to convert dash-less guids to dashed guids
        fixguid() {
          echo $1 | sed "s/\(.\{8\}\)\(.\{4\}\)\(.\{4\}\)\(.\{4\}\)\(.\{12\}\)/\1-\2-\3-\4-\5/"
        }
        getguid() {
          fixguid "$1" | clip
        }
      '';
  };
}
