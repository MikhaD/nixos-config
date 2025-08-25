{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [pip ipykernel]))
  ];

  home.sessionVariables = {
    PYTHON_HISTORY="$XDG_STATE_HOME/python_history"; # only works in python 3.13 and later (remove .python_history from ~)
    IPYTHONDIR="$XDG_CONFIG_HOME/ipython";           # Removes .ipython/ from ~
  };

  programs.bash.shellAliases = {
      py = "python"; # I am used to using py to run the python interpreter from windows
  };
}