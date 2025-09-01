{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [pip ipykernel]))
  ];

  home.sessionVariables = {
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history"; # only works in python 3.13 and later (remove .python_history from ~)
    IPYTHONDIR = "${config.xdg.configHome}/ipython"; # Removes .ipython/ from ~
  };

  programs.bash.shellAliases = {
    py = "python"; # I am used to using py to run the python interpreter from windows
  };
}
