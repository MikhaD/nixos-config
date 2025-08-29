{pkgs, ...}: {
  # See https://wiki.nixos.org/wiki/Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
