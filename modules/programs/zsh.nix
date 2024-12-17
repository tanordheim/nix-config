{
  config,
  home-manager,
  isDarwin,
  ...
}:
let
  codeDirectory =
    if isDarwin then "${config.my.osUser.home}/Code" else "${config.my.osUser.home}/code";

in
{
  programs.zsh.enable = true;

  my.user.programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
      catppuccin.enable = true;
    };

    completionInit = ''
      # Add a "c" function with an autocomplete definition to allow easily
      # changing working directory into a source code directory.
      c() { cd ${codeDirectory}/$1; }
      _c() { _files -W ${codeDirectory} -/;  }
      compdef _c c
    '';

    initExtra = ''
      # AUTO COMPLETION

      # Make completions:
      #  - case insensitive
      #  - accepting of abbreviations after ., _ or - (ie f.b -> foo.bar)
      #  - substring matching (ie. bar -> foobar)
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Colorize completions using default "ls" colors
      zstyle ':completion:*' list-colors '''

      # OPTIONS

      # .. is shortcut for cd ..
      setopt autocd

      # tab-completing a directory appends a slash at the end
      setopt autoparamslash

      # command- and argument-auto-correction
      setopt correct

      # print exit value for non-zero exit codes
      setopt printexitvalue

      # share history across shells
      setopt sharehistory

      # BINDINGS

      # emacs bindings.
      bindkey -e
    '';

    history = {
      size = 100000;
      path = "${config.my.user.xdg.dataHome}/zsh/history";
    };
  };
}
