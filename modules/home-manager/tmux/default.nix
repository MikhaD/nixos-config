{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.tmux;
in {
  options.tmux = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tmux.";
    };
    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-b";
      description = "Set tmux prefix key. Default is Ctrl + G.";
    };
    selectionColor = {
      background = lib.mkOption {
        type = lib.types.str;
        default = "#99CCE6";
        description = "Set the background color of the cursor selection.";
      };
      foreground = lib.mkOption {
        type = lib.types.str;
        default = "black";
        description = "Set the color of the text in a selection.";
      };
    };
    message = {
      duration = lib.mkOption {
        type = lib.types.int;
        default = 4000; # original default is 750
        description = "Set the duration (in milliseconds) for which tmux messages are displayed.";
      };
      color = {
        background = lib.mkOption {
          type = lib.types.str;
          default = "#D9AD8C";
          description = "Set the background color of tmux messages.";
        };
        foreground = lib.mkOption {
          type = lib.types.str;
          default = "black";
          description = "Set the foreground color of tmux messages.";
        };
      };
    };
    prompt.color = lib.mkOption {
      type = lib.types.str;
      default = "green";
      description = "Set the color of the session pill and active tab.";
    };
    prompt.info = lib.mkOption {
      type = lib.types.either lib.types.bool (lib.types.submodule {
        options = {
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
      });
      default = true;
      description = "Configure what info to show in the tmux status bar. Can be a boolean to enable/disable all info.";
    };
  };
  config = let
    # Normalize prompt.info to always be an attribute set
    promptInfo =
      if builtins.isBool cfg.prompt.info
      then {
        host = cfg.prompt.info;
        disk = cfg.prompt.info;
        memory = cfg.prompt.info;
        battery = cfg.prompt.info;
      }
      else cfg.prompt.info;
  in
    lib.mkIf cfg.enable {
      programs.tmux = {
        enable = true;
        # Start window & pane indexing at 1 (because 0 is further away on the keyboard)
        baseIndex = 1;
        mouse = true;
        keyMode = "vi";
        prefix = cfg.prefix;
        # Don't ask for confirmation when killing a tmux window or session
        disableConfirmationPrompt = true;
        extraConfig = let
          color = cfg.prompt.color;
        in
          lib.concatStringsSep "" ([
              (builtins.readFile ./tmux.conf)
              "\n"
              "set -g display-time ${toString cfg.message.duration}\n"
              "set-option -g message-style fg=${cfg.message.color.foreground},bg=${cfg.message.color.background}\n" # Tmux message colors
              "set-option -g mode-style fg=${cfg.selectionColor.foreground},bg=${cfg.selectionColor.background}\n\n" # Selection colors
              "set-option -g status-left '#[fg=${color}]#[bg=${color},fg=black] #S#[bg=default,fg=${color}]#[default] '\n"
              "set-option -g window-status-current-format '#[fg=${color}]#[bg=${color},fg=black]  #W #[fg=${color},bg=default]#[default]'\n"
              "set-option -g status-right \""
            ]
            ++ lib.optional promptInfo.host "#[fg=#99CCE6]#[bg=#99CCE6,fg=black]󰟀 #[default] #H "
            ++ lib.optional promptInfo.disk "#[fg=#999FE5]#[bg=#999FE5,fg=black]󰋊 #[default] #(_tmux-disk-fraction) "
            ++ lib.optional promptInfo.memory "#[fg=#BF99E5]#[bg=#BF99E5,fg=black]󰍛 #[default] #(_tmux-memory-fraction 1) "
            ++ lib.optional promptInfo.battery "#[fg=#E599DF]#[bg=#E599DF,fg=black]#(_tmux-battery-icon) #[default] #(cat /sys/class/power_supply/BAT0/capacity)%"
            ++ ["\""]);
      };
      # Requires login logout to take effect in tmux status bar
      home.packages =
        []
        ++ lib.optional promptInfo.disk (pkgs.writeShellScriptBin "_tmux-disk-fraction" (builtins.readFile ./scripts/disk-fraction.sh))
        ++ lib.optional promptInfo.memory (pkgs.writeShellScriptBin "_tmux-memory-fraction" (builtins.readFile ./scripts/memory-fraction.sh))
        ++ lib.optional promptInfo.battery (pkgs.writeShellScriptBin "_tmux-battery-icon" (builtins.readFile ./scripts/battery-icon.sh));
    };
}
