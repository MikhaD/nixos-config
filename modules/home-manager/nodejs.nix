{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nodePackages_latest.nodejs
  ];
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npmrc"; # Removes .npmrc from ~
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm"; # Removes .npm/ from ~
  };
}
