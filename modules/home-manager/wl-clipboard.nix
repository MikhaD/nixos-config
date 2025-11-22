{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard
  ];
  programs.bash.shellAliases = {
    # [[ -t 0 ]] is true if stdin is a terminal (i.e. data is NOT being piped in)
    cb = "([[ ! -t 0 ]] && wl-copy) || wl-paste"; # Make cb an alias that lets me pipe data to the clipboard, or paste from it
    sort-cb = "wl-paste | sort | wl-copy"; #        Sort the content of the clipboard
  };
}
