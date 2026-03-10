{
  details,
  lib,
  config,
  ...
}: {
  options.default-user = {
    enable = lib.mkEnableOption "default user creation using the details provided in the flake";
    extra = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional options or overrides to set on the default user.";
    };
    autoLogin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable autologin for the default user.";
    };
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional groups to add the default user to.";
    };
  };

  config = lib.mkIf config.default-user.enable {
    users.users.${details.username} =
      lib.recursiveUpdate {
        isNormalUser = true;
        description = details.fullName;
        extraGroups = ["networkmanager" "wheel"] ++ config.default-user.extraGroups;
      }
      config.default-user.extra;
    services.getty.autologinUser =
      if config.default-user.autoLogin
      then details.username
      else null;
  };
}
