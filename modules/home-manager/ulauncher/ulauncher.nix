{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ulauncher;
in {
  options.ulauncher = {
    enable = lib.mkEnableOption "Enable Ulauncher.";
    # Can't find this in UI, or figure out how to use it
    arrowKeyAliases = lib.mkOption {
      type = lib.types.str;
      default = "hjkl";
      description = "";
    };
    windowWidth = lib.mkOption {
      type = lib.types.int;
      default = 750;
      description = "Window width (in pixels). Min: 540, Max: 2000.";
    };
    clearPreviousQuery = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start each session with a blank query.";
    };
    closeOnFocusOut = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Close Ulauncher when losing focus.";
    };
    daemonlessMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Prevents keeping Ulauncher running in the background. Beware that this mode comes with some caveats and is not recommended.";
    };
    includeForeignDesktopApps = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Display all applications, even if they are configured not to show in the current desktop environment.";
    };
    includeApplicationsInSearch = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Disable if you only want to use Ulauncher for shortcuts and extensions.";
    };
    grabMousePointerFocus = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Prevent losing focus when using focus modes that follows the mouse to change focus to the window you hover over, ex 'Sloppy focus mode'.";
    };
    jumpKeys = lib.mkOption {
      type = lib.types.str;
      default = "1234567890abcdefghijklmnopqrstuvwxyz";
      description = "Set the keys to use for quickly jumping to results.";
    };
    maxRecentApps = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Number of frequent apps to show.";
    };
    raiseIfStarted = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Switch to application if it is already running. This feature only works on X11.";
    };
    showOnMouseScreen = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to show the window on the screen where the mouse pointer is located. If disabled, the launcher will appear on the default screen.";
    };
    terminalCommand = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Overrides terminal for commands that are configured to be run from a terminal. Uses the default terminal if not set.";
    };
    trayIcon.show = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Show Ulauncher icon in the system tray.";
    };
    trayIcon.dark = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the dark version of the tray icon. Only applies if showTrayIcon is true.";
    };
    theme = lib.mkOption {
      type = lib.types.enum ["dark" "light" "adwaita" "ubuntu"];
      default = "dark";
      description = "The name of the color theme to use.";
    };
    # extensions = {};
    shortcuts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          query = lib.mkOption {
            type = lib.types.str;
            description = "The query string or script to run when the shortcut is triggered. Use %s as the placeholder for the query.";
            default = null;
            example = lib.literalExample ''
              #!/bin/bash
              # Scripts must start with a shebang string ^
              # Run Ulauncher in verbose mode to log the output of the script (for debugging)
              # %s is supported for scripts as of Ulauncher v6
              # You can also use shell arguments
              # This can be a url or a shell script
              # URL Example:
              # "https://home-manager-options.extranix.com/?query=%s&release=master"
              echo "You wrote: %s"
              echo "This also works: $@"
            '';
          };
          icon = lib.mkOption {
            type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
            description = "The path to an image to show next to the shortcut when it appears in Ulauncher. The image should ideally be a 128x128 png or an svg.";
            default = null;
          };
          includeInFallbackForSearchResults = lib.mkOption {
            type = lib.types.bool;
            description = "Suggest this shortcut when no results are found. Ignored if this is a static shortcut.";
            default = false;
          };
          keyword = lib.mkOption {
            type = lib.types.str;
            description = "The prefix to trigger the shortcut. Type this followed by space to use the shortcut.";
            default = "";
            example = "hm";
          };
          name = lib.mkOption {
            type = lib.types.str;
            description = "The title of the shortcut when it appears in Ulauncher.";
            default = null;
            example = "Home Manager Search";
          };
          staticShortcut = lib.mkOption {
            type = lib.types.bool;
            description = "This shortcut doesn't take an argument.";
            default = false;
          };
        };
      });
    };
    # cant find json setting for UI settings ["launch at login"]
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.ulauncher6.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    xdg.configFile."ulauncher/settings.json".text = builtins.toJSON {
      arrow_key_aliases = cfg.arrowKeyAliases;
      base_width = cfg.windowWidth;
      clear_previous_query = cfg.clearPreviousQuery;
      close_on_focus_out = cfg.closeOnFocusOut;
      daemonless = cfg.daemonlessMode;
      disable_desktop_filters = cfg.includeForeignDesktopApps;
      enable_application_mode = cfg.includeApplicationsInSearch;
      grab_mouse_pointer = cfg.grabMousePointerFocus;
      jump_keys = cfg.jumpKeys;
      max_recent_apps = cfg.maxRecentApps;
      raise_if_started = cfg.raiseIfStarted;
      render_on_screen =
        if cfg.showOnMouseScreen
        then "mouse-pointer-monitor"
        else "default-monitor";
      show_tray_icon = cfg.trayIcon.show;
      terminal_command = cfg.terminalCommand;
      theme_name = cfg.theme;
      tray_icon_name =
        if cfg.trayIcon.dark
        then "ulauncher-indicator-symbolic-dark"
        else "ulauncher-indicator-symbolic";
    };
    xdg.configFile."ulauncher/shortcuts.json".text = builtins.toJSON (lib.mapAttrs (
        name: shortcut:
          {
            cmd = shortcut.query;
            id = name;
            is_default_search = shortcut.includeInFallbackForSearchResults;
            keyword = shortcut.keyword;
            name = shortcut.name;
            run_without_argument = shortcut.staticShortcut;
          }
          // lib.optionalAttrs (shortcut.icon != null) {icon = shortcut.icon;}
      )
      cfg.shortcuts);
  };
}
# TODO:
# self made themes
# extensions
# extension settings
# shortcuts
# disable the preferences GUI
# use config
# Example integration into a flake
# https://github.com/nazarewk-iac/nix-configs/commit/cc56c994ad889de04a1408d4ca57defb7e2e9349

