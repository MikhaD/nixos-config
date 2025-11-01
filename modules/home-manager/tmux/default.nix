{
  config,
  lib,
  pkgs,
  utils,
  ...
}: let
  cfg = config.tmux;
in {
  options.tmux = {
    enable = utils.mkEnableOptionTrue "Tmux";
    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-b";
      description = "Set tmux prefix key. Default is Ctrl + G.";
    };
    selection = {
      background = utils.mkHexColorOption "#99CCE6" "Set the background color of the cursor selection.";
      color = utils.mkHexColorOption "#000" "Set the color of the text in a selection.";
    };
    message = {
      duration = lib.mkOption {
        type = lib.types.int;
        default = 4000; # original default is 750
        description = "Set the duration (in milliseconds) for which tmux messages are displayed.";
      };
      color = utils.mkHexColorOption "#000" "Set the color of tmux messages.";
      background = utils.mkHexColorOption "#D9AD8C" "Set the background color of tmux messages.";
    };
    prompt = {
      color = utils.mkHexColorOption "#000" "Set the text color of the session pill and active tab.";
      background = utils.mkHexColorOption "#11D116" "Set the background color of the session pill and active tab.";
      info = lib.mkOption {
        type = lib.types.either lib.types.bool (lib.types.submodule {
          options = {
            host = {
              enable = utils.mkEnableOptionTrue "the host info section in the tmux status bar.";
              color = utils.mkHexColorOption "#000" "Set the color of the host indicator.";
              background = utils.mkHexColorOption "#99CCE6" "Set the background color of the host indicator.";
            };
            disk = {
              enable = utils.mkEnableOptionTrue "the disk usage info section in the tmux status bar";
              color = utils.mkHexColorOption "#000" "Set the color of the disk indicator.";
              background = utils.mkHexColorOption "#999FE5" "Set the background color of the disk indicator.";
            };
            memory = {
              enable = utils.mkEnableOptionTrue "the memory usage info section in the tmux status bar";
              color = utils.mkHexColorOption "#000" "Set the color of the memory indicator.";
              background = utils.mkHexColorOption "#BF99E5" "Set the background color of the memory indicator.";
            };
            battery = {
              enable = utils.mkEnableOptionTrue "the battery status info section in the tmux status bar";
              color = utils.mkHexColorOption "#000" "Set the color of the battery indicator.";
              background = utils.mkHexColorOption "#E599DF" "Set the background color of the battery indicator.";
            };
          };
        });
        default = true;
        description = "Configure what info to show in the tmux status bar. Can be a boolean to enable/disable all info.";
      };
    };
  };
  config = let
    # Normalize prompt.info to always be an attribute set
    pInf =
      if builtins.isBool cfg.prompt.info
      then {
        host = {
          enable = cfg.prompt.info;
          color = "#000000";
          background = "#99CCE6";
        };
        disk = {
          enable = cfg.prompt.info;
          color = "#000000";
          background = "#999FE5";
        };
        memory = {
          enable = cfg.prompt.info;
          color = "#000000";
          background = "#BF99E5";
        };
        battery = {
          enable = cfg.prompt.info;
          color = "#000000";
          background = "#E599DF";
        };
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
        extraConfig = lib.concatStringsSep "" ([
            (builtins.readFile ./tmux.conf)
            "\n"
            "set -g display-time ${toString cfg.message.duration}\n"
            "set-option -g message-style fg=${cfg.message.color},bg=${cfg.message.background}\n" # Tmux message colors
            "set-option -g mode-style fg=${cfg.selection.color},bg=${cfg.selection.background}\n\n" # Selection colors
            "set-option -g status-left '#[fg=${cfg.prompt.background}]#[bg=${cfg.prompt.background},fg=${cfg.prompt.color}] #S#[bg=default,fg=${cfg.prompt.background}]#[default] '\n"
            "set-option -g window-status-current-format '#[fg=${cfg.prompt.background}]#[bg=${cfg.prompt.background},fg=${cfg.prompt.color}]  #W #[fg=${cfg.prompt.background},bg=default]#[default]'\n"
            "\n"
            "set-option -g status-right \""
          ]
          ++ lib.optional pInf.host.enable "#[fg=${pInf.host.background}]#[bg=${pInf.host.background},fg=${pInf.host.color}]󰟀 #[default] #H "
          ++ lib.optional pInf.disk.enable "#[fg=${pInf.disk.background}]#[bg=${pInf.disk.background},fg=${pInf.disk.color}]󰋊 #[default] #(_tmux-disk-fraction) "
          ++ lib.optional pInf.memory.enable "#[fg=${pInf.memory.background}]#[bg=${pInf.memory.background},fg=${pInf.memory.color}]󰍛 #[default] #(_tmux-memory-fraction 1) "
          ++ lib.optional pInf.battery.enable "#[fg=${pInf.battery.background}]#[bg=${pInf.battery.background},fg=${pInf.battery.color}]#(_tmux-battery-icon) #[default] #(cat /sys/class/power_supply/BAT0/capacity)%"
          ++ ["\""]);
      };
      # Requires login logout to take effect in tmux status bar
      home.packages =
        []
        ++ lib.optional pInf.disk.enable (pkgs.writeShellScriptBin "_tmux-disk-fraction" (builtins.readFile ./scripts/disk-fraction.sh))
        ++ lib.optional pInf.memory.enable (pkgs.writeShellScriptBin "_tmux-memory-fraction" (builtins.readFile ./scripts/memory-fraction.sh))
        ++ lib.optional pInf.battery.enable (pkgs.writeShellScriptBin "_tmux-battery-icon" (builtins.readFile ./scripts/battery-icon.sh));
    };
}
