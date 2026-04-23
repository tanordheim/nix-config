{
  flake.modules.darwin.pdfexpert =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.pdfexpert.enable {
        homebrew.casks = [ "pdf-expert" ];
      };
    };
}
