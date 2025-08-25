{ ... }:
{
  programs.bash = {
    # Placed in /etc/bashrc
    initExtra = ''
      shopt -s histappend   # append to the history file, don't overwrite it
      shopt -s checkwinsize # check the window size after each command and update LINES and COLUMNS if necessary
      # shopt -s globstar   # Make the pattern "**" match all files in pathname expansion and 0 or more dirs and subdirs.

      bind "TAB: menu-complete"              # Use TAB to auto-complete
      bind "set completion-ignore-case on"   # Do not differentiate between upper and lower case when completing
      bind '"\e[A": history-search-backward' # Use ↑ to search backwards through your history for the text in the prompt
      bind '"\e[B": history-search-forward'  # Use ↓ to search forwards through your history for the text in the prompt
      # bind "set editing-mode vi"           # Use vi keybindings in the terminal (seems to prevent the use of the up and down arrow keys)
      # bind "set show-all-if-ambiguous on"  # print out all mathing files/directories if there are multiple possibilities
    '';
    # Placed in /etc/profile
    profileExtra = ''
      # Source .bashrc if it exists (tmux and login shells source .profile but not .bashrc)
      if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
      fi
    '';
    # My prompt is in .bashrc which is sourced above. If not set to empty default prompt overrides it in login shells
    # promptInit = "";
    shellAliases = {
      cls = "clear";               # clear screen using cls like windows powershell
      reload = "source ~/.bashrc"; # reload the bashrc file
      grep = "grep --color=auto";  # Use grep with color by default
      ls = "lsd";                  # Use lsd instead of ls
      ".." = "cd ..";              # Go up one directory
      wifi = "nmcli device wifi show-password"; # Print the wifi password & QR code to join
    };
  };

  home.sessionVariables = rec {
    # XDG Base directories: https://specifications.freedesktop.org/basedir-spec/latest
    XDG_DATA_HOME="$HOME/.local/share";  # User specific data files
    XDG_CONFIG_HOME="$HOME/.config";     # User specific configuration files
    XDG_STATE_HOME="$HOME/.local/state"; # User specific state files
    XDG_CACHE_HOME="$HOME/.cache";       # User specific non-essential data files

    # Bash history options. See bash man page for details
    HISTSIZE=2000;                       # Number of commands saved per session
    HISTFILESIZE=8000;                   # Number of lines stored in the history file
    HISTCONTROL="ignorespace:erasedups"; # ignore commands with leading whitespace; add each line only once, erasing prev occurrences

    # Home directory cleanup
    HISTFILE="${XDG_STATE_HOME}/bash_history"; # Removes .bash_history from ~

    NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npmrc";  # Removes .npmrc from ~
    NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm";          # Removes .npm/ from ~
    BOTO_CONFIG="${XDG_CONFIG_HOME}/botorc";           # Removes .boto from ~
    ANDROID_USER_HOME="${XDG_DATA_HOME}/android";      # Removes .android/ from ~
    MAVEN_OPTS="-Duser.home=${XDG_DATA_HOME}/maven";   # Removes .m2/ from ~
    JAVA_USER_HOME="${XDG_DATA_HOME}/java";            # Removes .java/ from ~
    GOPATH="${XDG_DATA_HOME}/go";                      # Removes go/ from ~
    LESSHISTFILE="${XDG_STATE_HOME}/lesshst";          # Removes .lesshst from ~
    WGETRC="${XDG_DATA_HOME}/wget-hsts";               # Removes .wget-hsts from ~
  };
}