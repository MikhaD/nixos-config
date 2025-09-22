{
  lib,
  config,
  details,
  inputs,
  ...
}: let
  cfg = config.home-config;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  options.home-config = {
    enable = lib.mkEnableOption "Enable home configuration via home-manager";
    modules = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = "List of home-manager modules to import for the user.";
    };
    sessionVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Session variables to set for the user.";
    };
    extra = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional options to set in the home-manager configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = {inherit details inputs;};
      users.${details.username} =
        lib.recursiveUpdate {
          imports = cfg.modules;
          home = {
            username = details.username;
            homeDirectory = "/home/${details.username}";

            sessionVariables =
              {
                LESSHISTFILE = "${config.home-manager.users.${details.username}.xdg.stateHome}/lesshst"; # Removes .lesshst from ~
              }
              // cfg.sessionVariables;

            # You can update Home Manager without changing this value. See
            # the Home Manager release notes for a list of state version
            # changes in each release.
            stateVersion = "25.05";
          };
        }
        cfg.extra;
    };
  };
}
