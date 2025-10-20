{config, lib, ...}: let
  cfg = config.termux;
in {
  options.termux = {
    properties = {
      allow-external-apps = lib.mkOption {
        type = lib.types.bool;
	default = false;
	description = "Allow external apps to execute arbitrary commands within Termux. This is disabled by default because of the security implications.";
      };
    };
    commands = {
      open = lib.mkOption {
        type = lib.types.bool;
	default = false;
	description = "";
      };
      open-url = lib.mkOption {
        type = lib.types.bool;
	default = false;
	description = "";
      };
      reload-settings = lib.mkOption {
        type = lib.types.bool;
	default = false;
	description = "";
      };
      setup-storage = lib.mkOption {
        type = lib.types.bool;
	default = false;
	description = "";
      };
      wake-lock = lib.mkOption {
        type = lib.types.bool;
	default = false;
	description = "";
      };
      wake-unlock = lib.mkOption {
        type = lib.types.bool;
	default = false;
	description = "";
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
  };
}
