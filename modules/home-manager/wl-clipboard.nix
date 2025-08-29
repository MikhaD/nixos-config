{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard
  ];
  programs.bash.shellAliases = {
    cb = "wl-copy"; # make cb an alias that lets me pipe data to the clipboard
    sort-cb = "wl-paste | sort | wl-copy"; # Sort the content of the clipboard
  };
}
