{ config, lib, ... }:
let
  skillsDir = ./skills;
  skills = builtins.attrNames (builtins.readDir skillsDir);
in
{
  home-manager.users.${config.username}.home.file = lib.mkMerge (
    map (skill: {
      ".claude/skills/${skill}".source = "${skillsDir}/${skill}";
    }) skills
  );
}
