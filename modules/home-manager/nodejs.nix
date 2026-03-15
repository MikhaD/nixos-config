{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nodejs_latest
  ];
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npmrc"; # Removes .npmrc from ~
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm"; # Removes .npm/ from ~
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history"; # Removes .node_repl_history from ~
  };
}
