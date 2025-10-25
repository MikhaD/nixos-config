{...}: {
  programs.grep.enable = true;
  programs.bash.shellAliases.grep = "grep --color=auto"; # Use grep with color by default
}
