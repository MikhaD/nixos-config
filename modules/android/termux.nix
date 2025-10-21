{
  config,
  lib,
  ...
}: let
  cfg = config.termux;

  # Function to convert an attribute set to the .properties file format
  toProperties = attrs: let
    toRawString = value:
      if builtins.isBool value
      then (builtins.toJSON value)
      else toString value;

    recurse = prefix:
      (key: value: let
        fullKey =
          if builtins.stringLength prefix > 0
          then "${prefix}.${key}"
          else key;
      in
        if builtins.isAttrs value
        then recurse fullKey value
        else "${fullKey} = ${toRawString value}")
      |> lib.mapAttrsToList;
  in
    (recurse "" attrs) |> lib.flatten |> builtins.concatStringsSep "\n";
in {
  options.termux = {
    # https://github.com/termux/termux-tools/blob/master/termux.properties
    # https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/settings/properties/TermuxPropertyConstants.java
    properties = {
      allow-external-apps = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allow external apps to execute arbitrary commands within Termux. This is disabled by default because of the security implications.";
      };
      default-working-directory = lib.mkOption {
        type = lib.types.str;
        default = "/data/data/com.termux.nix/files/home";
        description = "Default working directory that will be used when launching the app.";
      };
      disable-terminal-session-change-toast = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable toasts shown on terminal session change.";
      };
      hide-soft-keyboard-on-startup = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Don't show soft keyboard on application start.";
      };
      soft-keyboard-toggle-behavior = lib.mkOption {
        type = lib.types.enum ["enable/disable" "show/hide"];
        default = "show/hide";
        description = "Define the behavior of the keyboard toggle button";
      };
      terminal-transcript-rows = lib.mkOption {
        type = lib.types.int;
        default = 2000;
        description = "terminal scrollback buffer. Max is 50000. May have negative impact on performance.";
      };
      volume-keys = lib.mkOption {
        type = lib.types.enum ["volume" "virtual"];
        default = "virtual";
        # TODO: Figure out what the volume buttons do when not set to volume
        description = "Define the behavior of the volume buttons. If set to 'virtual', Volume down will act as Ctrl";
      };
      fullscreen = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Start terminal in fullscreen mode.";
      };
      use-fullscreen-workaround = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If the extra keys row is not visible with fullscreen enabled, enable this to fix it.";
      };
      terminal-cursor-blink-rate = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Set cursor blink rate (milliseconds between blinks). 0 means no blinking. Values 0, 100-2000.";
      };
      terminal-cursor-style = lib.mkOption {
        type = lib.types.enum ["block" "bar" "underline"];
        default = "block";
        description = "Set cursor style.";
      };
      extra-keys-style = lib.mkOption {
        type = lib.types.enum ["default" "arrows-only" "arrows-all" "all" "none"];
        default = "default";
        description = "Which set of symbols to use for illustrating keys.";
      };
      extra-keys-text-all-caps = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Force capitalize all text in extra keys row button labels.";
      };
      # TODO: Proper complex type
      extra-keys = lib.mkOption {
        type = lib.types.str;
        default = "[['ESC','/',{key: '-', popup: '|'},'HOME','UP','END','PGUP'], ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]";
        description = "Complex syntax that needs more work. See https://wiki.termux.com/wiki/Touch_Keyboard";
      };
      disable-hardware-keyboard-shortcuts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable hardware keyboard shortcuts. See https://wiki.termux.com/wiki/Hardware_Keyboard";
      };
      shortcut = {
        create-session = lib.mkOption {
          type = lib.types.str;
          default = "ctrl + t";
          description = "Keyboard shortcut to open a new terminal.";
        };
        next-session = lib.mkOption {
          type = lib.types.str;
          default = "ctrl + 2";
          description = "Keyboard shortcut to switch to the next terminal session.";
        };
        previous-session = lib.mkOption {
          type = lib.types.str;
          default = "ctrl + 1";
          description = "Keyboard shortcut to switch to the previous terminal session.";
        };
        rename-session = lib.mkOption {
          type = lib.types.str;
          default = "ctrl + n";
          description = "Keyboard shortcut to rename the current terminal session.";
        };
      };
      bell-character = lib.mkOption {
        type = lib.types.enum ["vibrate" "beep" "ignore"];
        default = "vibrate";
        description = "Action to perform when a bell character is received.";
      };
      back-key = lib.mkOption {
        type = lib.types.enum ["back" "escape"];
        default = "back";
        description = "Define the behavior of the back button. Back hides the keyboard or exits the app. Escape sends the ESC character.";
      };
      enforce-char-based-input = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Workaround for some Samsung devices. Turn this on if letters do not appear until enter is pressed.";
      };
      ctrl-space-workaround = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "ctrl+space (for marking text in emacs) does not work on some devices";
      };
      terminal-margin-horizontal = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Horizontal (left/right) Margin";
      };
      terminal-margin-vertical = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Vertical (top/bottom) Margin";
      };
    };

    commands = {
      open = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Provide a `termux-open` command that opens files or urls in external apps (uses `com.termux.app.TermuxOpenReceiver`).";
      };
      open-url = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Provide a `termux-open-url` command that opens files or urls in external apps (uses `android.intent.action.VIEW`).";
      };
      reload-settings = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Provide a `termux-reload-settings` command which applies changes to font, colorscheme or terminal without the need to close all the sessions.";
      };
      setup-storage = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Provide a `termux-setup-storage` command that makes the app request storage permission, and then creates a `$HOME/storage` directory with symlinks to storage.";
      };
      wake-lock = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Provide a `termux-wake-lock` command that tones down Android power saving measures. This is the same action that's available from the notification.";
      };
      wake-unlock = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Provide a `termux-wake-unlock` command that undoes the effect of the `termux-wake-lock` one.";
      };
    };
  };

  config = {
    android-integration = {
      termux-open.enable = cfg.commands.open;
      termux-open-url.enable = cfg.commands.open-url;
      termux-reload-settings.enable = cfg.commands.reload-settings;
      termux-setup-storage.enable = cfg.commands.setup-storage;
      termux-wake-lock.enable = cfg.commands.wake-lock;
      termux-wake-unlock.enable = cfg.commands.wake-unlock;
    };
    # termux.properties does not work if it is a symlink. Generate readonly file instead
    build.activation.termuxProperties = ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents ${config.user.home}/.termux
      if [[ -e ${config.user.home}/.termux/termux.properties ]]; then
        $DRY_RUN_CMD chmod $VERBOSE_ARG 600 ${config.user.home}/.termux/termux.properties
      fi
      $DRY_RUN_CMD cat <<EOF > ${config.user.home}/.termux/termux.properties
      ########################### 🛑 DO NOT EDIT 🛑 ###########################
      # Any changes made to this file will be overwritten on next activation. #
      ################### 🛑 THIS FILE IS AUTO GENERATED 🛑 ###################
      ${toProperties cfg.properties}
      EOF
      $DRY_RUN_CMD chmod $VERBOSE_ARG 400 ${config.user.home}/.termux/termux.properties
    '';
  };
}
