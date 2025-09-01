{config, ...}: {
  programs.bash = {
    enable = true;
    # Placed in ~/.bashrc
    initExtra = builtins.readFile ./bashrc;
    historyFile = "${config.xdg.stateHome}/bash_history";
    historyControl = ["ignorespace" "erasedups"]; # ignore commands with leading whitespace; add each line only once, erasing prev occurrences
    historySize = 2000; # Number of commands saved per session
    historyFileSize = 8000; # Number of lines stored in the history file
    # Placed in ~/.profile (not needed as home manager automatically create a .bash_profile that sources .bashrc)
    # profileExtra = ''
    #   # Source .bashrc if it exists (tmux and login shells source .profile but not .bashrc)
    #   if [ -f "$HOME/.bashrc" ]; then
    #     source "$HOME/.bashrc"
    #   fi
    # '';
    shellAliases = {
      cls = "clear"; # clear screen using cls like windows powershell
      reload = "source ~/.bashrc"; # reload the bashrc file
      grep = "grep --color=auto"; # Use grep with color by default
      ".." = "cd .."; # Go up one directory
      wifi = "nmcli device wifi show-password"; # Print the wifi password & QR code to join
    };
  };
}
