{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    # Start window & pane indexing at 1 (because 0 is further away on the keyboard)
    baseIndex = 1;
    mouse = true;
    newSession = true;
    keyMode = "vi";
    # Don't ask for confirmation when killing a tmux window or session
    disableConfirmationPrompt = true;
    extraConfig = builtins.readFile ./../../old-configs/tmux/tmux.conf;
  };

  # Requires login logout to take effect in tmux status bar
  home.packages = [
    (pkgs.writeShellScriptBin "tmux-battery-icon" (builtins.readFile ./../../old-configs/tmux/battery-icon))
    (pkgs.writeShellScriptBin "tmux-disk-fraction" (builtins.readFile ./../../old-configs/tmux/disk-fraction))
    (pkgs.writeShellScriptBin "tmux-memory-fraction" (builtins.readFile ./../../old-configs/tmux/memory-fraction))
  ];
}