{...}: {
  programs.bat = {
    enable = true;
    config = {
      # Each settings is equivalent to one of bat's cli flags. See `bat --help` for all options
      theme = "Visual Studio Dark+";
      tabs = "2";
      # `--mouse --wheel-lines=3` enables mouse support in less (which bat uses as a pager), so you can scroll with the
      # mouse in things like man and bat while in tmux, which would usually intercept scroll events
      # -r enables raw control characters, which is needed for Nerd Fonts to work properly
      # -F causes less to automatically exit if the content fits on one screen, making it behave like cat in that case
      pager = "less -r -F --mouse --wheel-lines=3";
    };
  };
}
