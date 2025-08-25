{ pkgs, details, ... }:
{
  imports = [
      ./programs/cli/bash.nix
      ./programs/cli/bat.nix
      ./programs/cli/git.nix
      ./programs/cli/neovim.nix
      ./programs/cli/python.nix
      # ./programs/cli/ssh.nix
      ./programs/cli/wl-clipboard.nix

      ./programs/gui/firefox.nix

      ./programs/work.nix
  ];
  home.username = details.username;
  home.homeDirectory = "/home/${details.username}";

  programs.home-manager.enable = true;
  programs.chromium.enable = true;

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

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}