{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [pip ipykernel]))
  ];

  home.sessionVariables = {
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history"; # Removes .python_history from ~ (v3.13+)
    IPYTHONDIR = "${config.xdg.configHome}/ipython"; #           Removes .ipython/ from ~
  };

  programs.bash.shellAliases = {
    py = "python"; # I am used to using py to run the python interpreter from windows
  };

  # if a .venv directory exists in the current directory, activate it.
  # This is only relevant when there is a .venv folder in the directory that a new shell is started in, which, in my case, is mainly relevant for tmux sessions.
  bash.extra = [
    ''
      if [[ -f ./.venv/bin/activate && -z $VIRTUAL_ENV ]]; then
        source ./.venv/bin/activate
      fi
    ''
  ];
}
