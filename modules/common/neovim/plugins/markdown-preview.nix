{
  programs.nixvim.plugins.markdown-preview = {
    enable = true;
    lazyLoad = {
      settings = {
        ft = "markdown";
        cmd = [
          "MarkdownPreview"
          "MarkdownPreviewStop"
          "MarkdownPreviewToggle"
        ];
      };
    };
  };
}
