{...}: {
  programs.lsd = {
    enable = true;
    enableBashIntegration = true;
    icons = {
      extension = {
        markdown = "";
        md = "";
        yaml = "";
        yml = "";
      };
      # Folders match my .bashrc icons (Names must be in lower case)
      # Icons from https://www.nerdfonts.com/cheat-sheet
      # defaults: https://github.com/lsd-rs/lsd/blob/master/src/theme/icon.rs
      name = {
        "android" = "";
        ".bash_profile" = "";
        ".bashrc" = "";
        "bashrc" = "";
        "bash.rc" = "";
        "bin" = "";
        ".cache" = "󱘿";
        ".config" = "";
        "desktop" = "";
        "development" = "󰘦";
        ".docker" = "";
        ".dockerignore" = "";
        "documents" = "󱔗";
        "downloads" = "󰉍";
        "etc" = "";
        ".gcs" = "󰆼";
        ".gcloudignore" = "󱇶";
        ".git" = "";
        ".github" = "";
        ".idea" = "";
        ".java" = "";
        "lib" = "";
        "lib64" = "";
        "media" = "󰕓";
        "mnt" = "";
        ".mozilla" = "󰈹";
        "music" = "󱍙";
        "nix" = "";
        "nixos" = "";
        ".npm" = "";
        "opt" = "";
        "pictures" = "󰉏";
        "proc" = "";
        ".profile" = "";
        "Public" = "";
        "root" = "󰉐";
        "tmp" = "";
        ".tmux" = "";
        "tmux.conf" = "";
        "usr" = "󰪋";
        "var" = "";
        "videos" = "󰨜";
        ".vim" = "";
        ".vscode" = "";
      };
    };
  };
}
