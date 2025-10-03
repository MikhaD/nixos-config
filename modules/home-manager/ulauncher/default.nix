{
  inputs,
  pkgs,
  config,
  ...
}: let
  cfg = config.ulauncher;
in {
  options.ulauncher = {
    enable = pkgs.lib.mkEnableOption "Enable Ulauncher.";
    # Can't find this in UI, or figure out how to use it
    arrowKeyAliases = pkgs.lib.mkOption {
      type = pkgs.lib.types.string;
      default = "hjkl";
      description = "";
    };
    windowWidth = pkgs.lib.mkOption {
      type = pkgs.lib.types.int;
      default = 750;
      description = "Window width (in pixels). Min: 540, Max: 2000.";
    };
    clearPreviousQuery = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = true;
      description = "Start each session with a blank query.";
    };
    closeOnFocusOut = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = true;
      description = "Close Ulauncher when losing focus.";
    };
    daemonlessMode = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Prevents keeping Ulauncher running in the background. Beware that this mode comes with some caveats and is not recommended.";
    };
    includeForeignDesktopApps = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Display all applications, even if they are configured not to show in the current desktop environment.";
    };
    includeApplicationsInSearch = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = true;
      description = "Disable if you only want to use Ulauncher for shortcuts and extensions.";
    };
    grabMousePointerFocus = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Prevent losing focus when using focus modes that follows the mouse to change focus to the window you hover over, ex 'Sloppy focus mode'.";
    };
    jumpKeys = pkgs.lib.mkOption {
      type = pkgs.lib.types.string;
      default = "1234567890abcdefghijklmnopqrstuvwxyz";
      description = "Set the keys to use for quickly jumping to results.";
    };
    maxRecentApps = pkgs.lib.mkOption {
      type = pkgs.lib.types.int;
      default = 0;
      description = "Number of frequent apps to show.";
    };
    raiseIfStarted = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Switch to application if it is already running. This feature only works on X11.";
    };
    showOnMouseScreen = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = true;
      description = "Whether to show the window on the screen where the mouse pointer is located. If disabled, the launcher will appear on the default screen.";
    };
    trayIcon.show = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = true;
      description = "Show Ulauncher icon in the system tray.";
    };
    trayIcon.dark = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Use the dark version of the tray icon. Only applies if showTrayIcon is true.";
    };
    theme = pkgs.lib.mkOption {
      type = pkgs.lib.types.enum ["dark" "light" "adwaita" "ubuntu"];
      default = "dark";
      description = "The name of the color theme to use.";
    };
    # cant find json setting for UI settings ["launch at login"]
  };

  config = pkgs.lib.mkIf cfg.enable {
    home.packages = [
      inputs.ulauncher6.packages.${pkgs.system}.default
    ];
    xdg.dataFile."ulauncher/settings.json".text = builtins.toJSON {
      arrow_key_aliases = cfg.arrowKeyAliases;
      base_width = cfg.windowWidth;
      clear_previous_query = cfg.clearPreviousQuery;
      close_on_focus_out = cfg.closeOnFocusOut;
      daemonless = cfg.daemonlessMode;
      disable_desktop_filters = !cfg.includeForeignDesktopApps;
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
      theme_name = cfg.theme;
      tray_icon_name =
        if cfg.trayIcon.dark
        then "ulauncher-indicator-symbolic-dark"
        else "ulauncher-indicator-symbolic";
    };
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

