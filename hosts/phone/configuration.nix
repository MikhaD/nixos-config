{
  config,
  details,
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment.packages = with pkgs; [
    man
    openssh
    gnugrep
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit details inputs;};
    config = {pkgs, ...}: {
      imports = [
        ./../../modules/home-manager/bash
	./../../modules/home-manager/bat.nix
	./../../modules/home-manager/dig.nix
	./../../modules/home-manager/fastfetch.nix
        ./../../modules/home-manager/git.nix
        ./../../modules/home-manager/lsd.nix
        ./../../modules/home-manager/neovim.nix
        ./../../modules/home-manager/tmux
      ];
      home.stateVersion = "24.05";
    };
  };

  android-integration = {
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
  };

  terminal.font = pkgs.runCommand "font" {} ''
    cp ${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf $out
  '';

  environment.motd = ""; # Do not show text at the top of the screen each time a new shell is created

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".old";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";
}
