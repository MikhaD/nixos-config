# available options: https://nix-community.github.io/nix-on-droid/nix-on-droid-options.html
{
  details,
  inputs,
  pkgs,
  myLib,
  ...
}: {
  imports = [
    # ./../../../modules/android/sshd.nix
    ./../../../modules/android/termux.nix
  ];
  user.userName = details.username;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  nix.extraOptions = "experimental-features = nix-command flakes pipe-operators";

  environment.packages = with pkgs; [
    coreutils
    findutils
    gawk
    gnused
    nettools
    openssh
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit details inputs myLib;
    };
    config = {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ./../../../modules/home-manager/bash
        ./../../../modules/home-manager/bat.nix
        ./../../../modules/home-manager/dig.nix
        ./../../../modules/home-manager/e.nix
        ./../../../modules/home-manager/fastfetch.nix
        ./../../../modules/home-manager/fzf.nix
        ./../../../modules/home-manager/git.nix
        ./../../../modules/home-manager/grep.nix
        ./../../../modules/home-manager/lsd.nix
        ./../../../modules/home-manager/neovim.nix
        ./../../../modules/home-manager/nom.nix
        ./../../../modules/home-manager/ssh.nix
        ./../../../modules/home-manager/tmux
        ./../../../modules/home-manager/xdg.nix
      ];
      programs.nix-index.enable = true;
      programs.bash.shellAliases = {
        clear = "printf '\\033[2J\\033[H'"; # This shell does not come with a clear command, so this aliases clear to Ctrl + L
        rebuild = "nix-on-droid switch --flake ~/nix |& nom";
      };
      tmux = {
        prefix = "C-g";
        prompt = {
          color = "#87D7D7";
          info = false;
        };
      };
      home.stateVersion = "24.05";
    };
  };

  termux = {
    commands = {
      setup-storage = true;
      wake-lock = true;
      wake-unlock = true;
    };
    properties = {
      soft-keyboard-toggle-behavior = "enable/disable";
      volume-keys = "volume";
      fullscreen = true;
      terminal-cursor-blink-rate = 500;
      terminal-cursor-style = "bar";
      extra-keys = "[['ESC','TAB','CTRL','ALT','HOME','END','PGUP','PGDN']]";
    };
  };

  time.timeZone = details.timeZone;
  terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
  # Text printed to the top of the screen in new shells
  environment.motd = ''
     Tmux meta key is Ctrl + G
     Long press KEYBOARD button to toggle extra keys row
  '';
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".old";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";
}
