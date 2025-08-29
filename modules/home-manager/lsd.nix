{...}: {
  programs.lsd = {
    enable = true;
    enableBashIntegration = true;
    icons = {
      extension = {
        dockerignore = "";
        gcloudignore = "󱇶";
        markdown = "";
        md = "";
        yaml = "";
        yml = "";
      };
      # Folders match my .bashrc icons
      # Icons from https://www.nerdfonts.com/cheat-sheet
      name = {
        "android" = "";
        "Android" = "";
        ".bash_profile" = "";
        ".bashrc" = "";
        "bashrc" = "";
        "bin" = "";
        ".cache" = "󱘿";
        ".config" = "";
        "Desktop" = "";
        "Development" = "󰘦";
        ".docker" = "";
        "Documents" = "󱔗";
        "Downloads" = "󰉍";
        "etc" = "";
        ".gcs" = "󰆼";
        ".git" = "";
        ".github" = "";
        ".idea" = "";
        ".java" = "";
        "lib" = "";
        "lib64" = "";
        "media" = "󰕓";
        "mnt" = "";
        ".mozilla" = "󰈹";
        "Music" = "";
        "nix" = "";
        "nixos" = "";
        ".npm" = "";
        "opt" = "";
        "Pictures" = "";
        "proc" = "";
        ".profile" = "";
        "Public" = "";
        "root" = "󰉐";
        "tmp" = "";
        ".tmux" = "";
        "tmux.conf" = "";
        "usr" = "󰪋";
        "var" = "";
        "Videos" = "󰨜";
        ".vim" = "";
        ".vscode" = "";
      };
    };
  };
}
