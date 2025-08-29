{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages_latest.nodejs
  ];
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npmrc"; # Removes .npmrc from ~
    NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm"; # Removes .npm/ from ~
  };
}
