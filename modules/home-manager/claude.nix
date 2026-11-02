{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
    # See all possible settings here: https://code.claude.com/docs/en/settings-reference
    settings = {
      effortLevel = "high";
      tui = "fullscreen";
      feedbackDrafts = "off";
      spellcheck = {
        enabled = true;
        "language" = "en_US";
      };
      # advisorModel = "opus"; # runs up usage
      cleanupPeriodDays = 28;
      enabledPlugins = {
        "cc-plugin-you-should-know@builtin" = true;
        "cc-plugin-mermaid@builtin" = true;

        "cc-plugin-telemetry@builtin" = false;
      };
    };
    mcpServers = {
      # nixos = {
      #   type = "stdio";
      #   command = lib.getExe pkgs.mcp-nixos;
      # };
      svelte = {
        type = "http";
        url = "https://mcp.svelte.dev/mcp";
      };
      serena = {
        type = "stdio";
        command = lib.getExe inputs.serena.packages.${pkgs.stdenv.system}.default;
        args = [
          "start-mcp-server"
          "--context=claude-code"
          "--project-from-cwd"
          "--open-web-dashboard"
          "False"
        ];
      };
      cloudflare = {
        type = "http";
        url = "https://docs.mcp.cloudflare.com/mcp";
      };
    };
  };

  # Linked directly rather than via programs.claude-code.plugins: that option wraps the plugin in a directory of
  # top-level symlinks, so Claude Code rejects ponytail's manifest hook paths as escaping the plugin directory.
  home.file."${config.programs.claude-code.configDir}/skills/ponytail".source = inputs.ponytail;

  home.sessionVariables = {
    # Avoid sending all tool descriptions to Claude upon startup, thus saving tokens. Instead, Claude will search for tools as needed (but there are no guarantees that it will search optimally, of course).
    # ENABLE_TOOL_SEARCH = "true";
    SERENA_HOME = "${config.xdg.configHome}/serena"; # Removes .serena from ~
  };
}
