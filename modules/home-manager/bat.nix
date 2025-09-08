{...}: {
  programs.bat = {
    enable = true;
    config = {
      # Each settings is equivalent to one of bat's cli flags. See `bat --help` for all options
      theme = "Visual Studio Dark+";
      tabs = "2";
    };
  };
    home.sessionVariables = {
    # Use bat as the man pages pager (`--plain` disables decorations like line numbers, git markers & file name header)
    MANPAGER = "bat --language man --plain";
    # `--mouse --wheel-lines=3` enables mouse support in less (which bat uses as a pager), so you can scroll with the
    # mouse in things like man and bat while in tmux, which would usually intercept scroll events
    # -r enables raw control characters, which is needed for Nerd Fonts to work properly
    LESS = "-r --mouse --wheel-lines=3";
  };
}
