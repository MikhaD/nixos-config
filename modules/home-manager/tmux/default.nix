{
  config,
  lib,
  pkgs,
  myLib,
  ...
}: let
  cfg = config.tmux;
in {
  options.tmux = {
    enable = myLib.mkEnableOptionTrue "Tmux";
    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-b";
      description = "Set tmux prefix key. Default is Ctrl + G.";
    };
    selection = {
      background = myLib.mkHexColorOption "#99CCE6" "Set the background color of the cursor selection.";
      color = myLib.mkHexColorOption "#000" "Set the color of the text in a selection.";
    };
    message = {
      duration = lib.mkOption {
        type = lib.types.int;
        default = 4000; # original default is 750
        description = "Set the duration (in milliseconds) for which tmux messages are displayed.";
      };
      color = myLib.mkHexColorOption "#000" "Set the color of tmux messages.";
      background = myLib.mkHexColorOption "#D9AD8C" "Set the background color of tmux messages.";
    };
    prompt = {
      color = myLib.mkHexColorOption "#000" "Set the text color of the session pill and active tab.";
      background = myLib.mkHexColorOption "#11D116" "Set the background color of the session pill and active tab.";
      info = lib.mkOption {
        type = lib.types.either lib.types.bool (lib.types.submodule {
          options = {
            host = {
              enable = myLib.mkEnableOptionTrue "the host info section in the tmux status bar.";
              color = myLib.mkHexColorOption "#000" "Set the color of the host indicator.";
              background = myLib.mkHexColorOption "#99CCE6" "Set the background color of the host indicator.";
            };
            disk = {
              enable = myLib.mkEnableOptionTrue "the disk usage info section in the tmux status bar";
              color = myLib.mkHexColorOption "#000" "Set the color of the disk indicator.";
              background = myLib.mkHexColorOption "#999FE5" "Set the background color of the disk indicator.";
            };
            memory = {
              enable = myLib.mkEnableOptionTrue "the memory usage info section in the tmux status bar";
              color = myLib.mkHexColorOption "#000" "Set the color of the memory indicator.";
              background = myLib.mkHexColorOption "#BF99E5" "Set the background color of the memory indicator.";
            };
            battery = {
              enable = myLib.mkEnableOptionTrue "the battery status info section in the tmux status bar";
              color = myLib.mkHexColorOption "#000" "Set the color of the battery indicator.";
              background = myLib.mkHexColorOption "#E599DF" "Set the background color of the battery indicator.";
            };
          };
        });
        default = true;
        description = "Configure what info to show in the tmux status bar. Can be a boolean to enable/disable all info.";
      };
    };
    autoAttach = {
      enable = lib.mkEnableOption "automatically attach to a tmux session when starting a terminal";
      sshOnly = lib.mkEnableOption "auto attach only when connecting over SSH";
      defaultSessionName = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "The name of the tmux session to attach to or create.";
      };
    };
    motd = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Set a custom message of the day (MOTD) to display when starting a new tmux session.";
      example = "Remember that the tmux meta key is Ctrl + B";
    };
    tat = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the 'tat' (tmux attach or create) helper script. This requires that fzf be installed.";
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
        ++ lib.optional pInf.battery.enable (pkgs.writeShellScriptBin "_tmux-battery-icon" (builtins.readFile ./scripts/battery-icon.sh))
        ++ lib.optional cfg.tat (pkgs.writeShellScriptBin "tat" (builtins.readFile ./scripts/tat/tat.sh));

      bash.completions.tat = ./scripts/tat/tat.completions.sh;

      bash.extra = let
        sshOnly = str:
          if cfg.autoAttach.sshOnly
          then str
          else "";
      in
        []
        ++ lib.optional cfg.autoAttach.enable ''
          # Automatically attach to a tmux session if one exists, or create a new one
          ${sshOnly "# check SSH_TTY to only do this for SSH sessions"}
          # check $TMUX to avoid nesting tmux sessions
          ${sshOnly " [[ -n $SSH_TTY ]] &&"} [[ -z $TMUX ]] && tmux new -As "${cfg.autoAttach.defaultSessionName}"
        ''
        ++ lib.optional (cfg.motd != "") "[[ -n $TMUX ]] && echo '${cfg.motd}'";
    };
}
