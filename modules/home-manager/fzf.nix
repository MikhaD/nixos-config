{...}: {
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    tmux.enableShellIntegration = true;
    defaultOptions = [
      "--tabstop=4"
      "--highlight-line"
      "--border=rounded"
      "--reverse"
      "--prompt='  '"
      "--height=95%"
    ];
  };
  # alternative search icons:     
}
