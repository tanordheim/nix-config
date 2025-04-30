{
  config,
  pkgs,
  ...
}:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    package = pkgs._1password-gui.overrideAttrs (oldAttrs: {
      postInstall = ''
        ${oldAttrs.postInstall or ""}
        substituteInPlace $out/share/applications/1password.desktop \
          --replace "Exec=1password %U" 'Exec=1password --js-flags="--no-decommit-pooled-pages" %U'
      '';
    });
    polkitPolicyOwners = [ config.username ];
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      brave
    '';
    mode = "0755";
  };
}
