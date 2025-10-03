{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.tmux;
in {
  options.tmux = {
    enable = lib.mkEnableOption "Enable tmux.";
    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-b";
      description = "Set tmux prefix key. Default is Ctrl + G.";
    };
    color = lib.mkOption {
      type = lib.types.str;
      default = "green";
      description = "Set the color of the session pill and active tab.";
    };
    prompt.info = {
      host = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show host in tmux status bar.";
      };
      disk = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show disk usage in tmux status bar.";
      };
      memory = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show memory usage in tmux status bar.";
      };
      battery = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show battery status in tmux status bar.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      # Start window & pane indexing at 1 (because 0 is further away on the keyboard)
      baseIndex = 1;
      mouse = true;
      keyMode = "vi";
      prefix = cfg.prefix;
      # Don't ask for confirmation when killing a tmux window or session
      disableConfirmationPrompt = true;
      extraConfig = lib.concatStringsSep "" ([
          (builtins.readFile ./tmux.conf)
          "set-option -g status-left '#[fg=${cfg.color}]#[bg=${cfg.color},fg=black] #S#[bg=default,fg=${cfg.color}]#[default] '\n"
          "set-option -g window-status-current-format '#[fg=${cfg.color}]#[bg=${cfg.color},fg=black]  #W #[fg=${cfg.color},bg=default]#[default]'\n"
          "set-option -g status-right \""
        ]
        ++ lib.optional cfg.prompt.info.host "#[fg=#99CCE6]#[bg=#99CCE6,fg=black]󰟀 #[default] #H "
        ++ lib.optional cfg.prompt.info.disk "#[fg=#999FE5]#[bg=#999FE5,fg=black]󰋊 #[default] #(tmux-disk-fraction) "
        ++ lib.optional cfg.prompt.info.memory "#[fg=#BF99E5]#[bg=#BF99E5,fg=black]󰍛 #[default] #(tmux-memory-fraction 1) "
        ++ lib.optional cfg.prompt.info.battery "#[fg=#E599DF]#[bg=#E599DF,fg=black]#(tmux-battery-icon) #[default] #(cat /sys/class/power_supply/BAT0/capacity)%"
        ++ ["\""]);
    };
    # Requires login logout to take effect in tmux status bar
    home.packages =
      []
      ++ lib.optional cfg.prompt.info.disk (pkgs.writeShellScriptBin "tmux-disk-fraction" (builtins.readFile ./disk-fraction.sh))
      ++ lib.optional cfg.prompt.info.memory (pkgs.writeShellScriptBin "tmux-memory-fraction" (builtins.readFile ./memory-fraction.sh))
      ++ lib.optional cfg.prompt.info.battery (pkgs.writeShellScriptBin "tmux-battery-icon" (builtins.readFile ./battery-icon.sh));
  };
}
