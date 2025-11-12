{
  config,
  lib,
  ...
}: {
  programs.lsd = {
    enable = true;
    enableBashIntegration = true;
    icons = {
      extension = {
        markdown = "";
        md = "";
        properties = "";
        toml = "";
        yaml = "";
        yml = "";
        eot = "";
        flf = "󰛖";
        font = "";
        otf = "";
        ttc = "";
        ttf = "";
        woff = "";
        woff2 = "";
      };
      # Names must be lowercase
      # Icons from https://www.nerdfonts.com/cheat-sheet
      # defaults: https://github.com/lsd-rs/lsd/blob/master/src/theme/icon.rs
      name =
        {
          ".bash_profile" = "";
          ".bashrc" = "";
          "bashrc" = "";
          "bash.rc" = "";
          ".dockerignore" = "";
          ".gcs" = "󰆼";
          ".gcloudignore" = "󱇶";
          ".idea" = "";
          ".profile" = "";
          "tmux.conf" = "";
        }
        // (lib.mapAttrs' (name: value: {
            name = lib.toLower name;
            inherit value;
          })
          config.bash.prompt.section.directory.icons);
    };
  };
}
