{
  details,
  lib,
  config,
  ...
}: {
  options.default-user = {
    enable = lib.mkEnableOption "Create a user with the details provided in the flake.";
    extra = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional options or overrides to set on the default user.";
    };
    autoLogin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable autologin for the default user.";
    };
  };

  config = lib.mkIf config.default-user.enable {
    users.users.${details.username} =
      lib.recursiveUpdate {
        isNormalUser = true;
        description = details.fullName;
        extraGroups = ["networkmanager" "wheel" "podman"];
      }
      config.default-user.extra;
    services.getty.autologinUser =
      if config.default-user.autoLogin
      then details.username
      else null;
  };
}
