# available options: https://nix-community.github.io/nix-on-droid/nix-on-droid-options.html
{
  config,
  details,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    #./modules/sshd.nix
    #./modules/termux.nix
  ];
  user.userName = details.username;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  nix.extraOptions = "experimental-features = nix-command flakes";

  environment.packages = with pkgs; [
    coreutils
    gnugrep
    findutils
    openssh
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit details inputs;};
    config = {
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
        clear = "printf '\\033[2J\\033[H'"; # This shell does not come with a clear command, so this aliases clear to Ctrl + L
      };
      tmux = {
        prefix = "C-g";
	prompt = {
          color = "#87D7D7";
	  info = {
            disk = false;
	    memory = false;
	    battery = false;
	  };
	};
      };
      home.stateVersion = "24.05";
    };
  };

  android-integration = {
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
  };

  time.timeZone = details.timeZone;
  terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
  environment.motd = "Tmux meta key is Ctrl + G"; # Text at the top of the screen each time a new shell is created
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".old";

  # termux.properties does not work if it is a symlink
  build.activation.termuxProperties = ''
    if [[ -e ${config.user.home}/.termux/termux.properties ]]; then
      $DRY_RUN_CMD rm $VERBOSE_ARG ${config.user.home}/.termux/termux.properties
    fi
    $DRY_RUN_CMD cp $VERBOSE_ARG ${./termux.properties} ${config.user.home}/.termux/termux.properties
    $DRY_RUN_CMD chmod $VERBOSE_ARG 600 ${config.user.home}/.termux/termux.properties
  '';

  build.activation.sshd = ''
    
  '';

  # Read the changelog before changing this value
  system.stateVersion = "24.05";
}
