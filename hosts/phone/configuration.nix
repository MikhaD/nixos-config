{
  config,
  details,
  inputs,
  lib,
  pkgs,
  ...
}: {
  nix.extraOptions = "experimental-features = nix-command flakes";
  environment.packages = with pkgs; [
    man
    openssh
    gnugrep
    which
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
        ./../../modules/home-manager/fzf.nix
        ./../../modules/home-manager/git.nix
        ./../../modules/home-manager/lsd.nix
        ./../../modules/home-manager/neovim.nix
        ./../../modules/home-manager/tmux
        ./../../modules/home-manager/xdg.nix
      ];
      programs.bash.shellAliases = {
        clear = "printf '\\033[2J\\033[H'"; # For some reason this shell does not come with a clear command, so this aliases clear to Ctrl + L
      };
      #home.file.".termux/termux.properties".source = ./termux.properties;
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

  # termux properties does not work if it is a symlink
  build.activation.termuxProperties = ''
    if [[ -e $HOME/.termux/termux.properties ]]; then
      rm $HOME/.termux/termux.properties
    fi
    cp ${./termux.properties} $HOME/.termux/termux.properties
  '';

  # Read the changelog before changing this value
  system.stateVersion = "24.05";
}
