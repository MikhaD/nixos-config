{ ... }:
{
  programs.bash = {
    enable = true;
    # Placed in ~/.bashrc
    initExtra = builtins.readFile ./bashrc;
    # Placed in ~/.profile (not needed as home manager automatically create a .bash_profile that sources .bashrc)
    # profileExtra = ''
    #   # Source .bashrc if it exists (tmux and login shells source .profile but not .bashrc)
    #   if [ -f "$HOME/.bashrc" ]; then
    #     source "$HOME/.bashrc"
    #   fi
    # '';
    shellAliases = {
      cls = "clear";                            # clear screen using cls like windows powershell
      reload = "source ~/.bashrc";              # reload the bashrc file
      grep = "grep --color=auto";               # Use grep with color by default
      ls = "lsd";                               # Use lsd instead of ls
      ".." = "cd ..";                           # Go up one directory
      wifi = "nmcli device wifi show-password"; # Print the wifi password & QR code to join
    };
  };
}