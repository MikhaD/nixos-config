{config, ...}: {
  programs.bash = {
    enable = true;
    # Placed in ~/.bashrc
    initExtra = builtins.readFile ./bashrc;
    historyFile = "${config.xdg.stateHome}/bash_history";
    historyControl = ["ignoreboth" "erasedups"]; # ignore commands with leading whitespace; add each line only once, erasing prev occurrences
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
      grep = "grep --color=auto"; # Use grep with color by default
      wifi = "nmcli device wifi show-password"; # Print the wifi password & QR code to join
    };
    # All options: https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
    shellOptions = [
      "histappend" #              Append to the history file, don't overwrite it
      "checkwinsize" #            Check the window size after each command and update LINES and COLUMNS if necessary
      "extglob" #                 Extended pattern matching features
      "globstar" #                Make the pattern "**" match all files in pathname expansion and 0 or more dirs and subdirs.
      "checkjobs" #               List the status of any stopped and running jobs before exiting the shell
      "dirspell" #                Auto-correct directory names
      "cdspell" #                 Auto-correct minor spelling errors in the argument to the cd builtin
      "no_empty_cmd_completion" # Do not perform command completion on an empty command line
      "autocd" #                  Change to a directory just by typing its name
    ];
  };
}
