{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font Mono 12";
    theme = "material";
    cycle = false;
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji
    ];
    modes = [
      "drun"
      "ssh"
      "run"
      "combi"
      "filebrowser"
      "emoji"
      "calc"
    ];
    extraConfig = {
      show-icons = true;
      combi-modes = [
        "drun"
        "ssh"
        "emoji"
      ];
    };
  };
}
