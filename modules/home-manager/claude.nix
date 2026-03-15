{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.claude-code = {
    enable = true;
    mcpServers = {
      svelte = {
        type = "http";
        url = "https://mcp.svelte.dev/mcp";
      };
      serena = {
        type = "stdio";
        # need to use getExe' because serena flake does not specify a meta property
        # command = lib.getExe inputs.serena.packages.${pkgs.stdenv.system}.default;
        command = lib.getExe' inputs.serena.packages.${pkgs.stdenv.system}.default "serena";
        args = [
          "start-mcp-server"
          "--context=claude-code"
          "--project-from-cwd"
          "--open-web-dashboard"
          "False"
        ];
      };
    };
  };

  home.sessionVariables = {
    # Avoid sending all tool descriptions to Claude upon startup, thus saving tokens. Instead, Claude will search for tools as needed (but there are no guarantees that it will search optimally, of course).
    # ENABLE_TOOL_SEARCH = "true";
    SERENA_HOME = "${config.xdg.configHome}/serena"; # Removes .serena from ~
  };
}
