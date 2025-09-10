{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "JetBrainsMono Nerd Font Mono 12";
    theme = "material";
    cycle = false;
    plugins = [
      pkgs.rofi-emoji
      # Should be able to remove this override when rofi updates to 2.0.0 and I switch to that instead of rofi-wayland
      (pkgs.rofi-calc.override {
        rofi-unwrapped = pkgs.rofi-wayland;
      })
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
