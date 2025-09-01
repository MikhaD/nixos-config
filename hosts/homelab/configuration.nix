{config, ...}: {
  imports = [
    ./hardware-configuration.nix

    ./../../modules/home-manager
    ./../../modules/nixos/services/sshd
    ./../../modules/nixos/services/tlp.nix
    ./../../modules/nixos/system/boot.nix
    ./../../modules/nixos/system/gc.nix
    ./../../modules/nixos/programs/nix-ld.nix
    ./../../modules/nixos/system/user.nix
  ];

  # networking.firewall.allowedTCPPorts = [80 443];

  default-user.enable = true;
  default-user.autoLogin = true;

  home-config = {
    enable = true;
    modules = [
      ./../../modules/home-manager/bash
      ./../../modules/home-manager/bat.nix
      ./../../modules/home-manager/fastfetch.nix
      ./../../modules/home-manager/git.nix
      ./../../modules/home-manager/lsd.nix
      ./../../modules/home-manager/neovim.nix
      ./../../modules/home-manager/speedtest-cli.nix
      ./../../modules/home-manager/tmux
      ./../../modules/home-manager/tree.nix
    ];
    sessionVariables = {
      LESSHISTFILE = "${config.xdg.stateHome}/lesshst";
    };
    extra = {
      programs.bash.profileExtra = ''
        SNAME="homelab"
        if [ -z "$TMUX" ]; then
          if ! tmux has-session -t "$SNAME" 2>/dev/null; then
            tmux new-session -s "$SNAME"
          else
           tmux attach-session -t "$SNAME"
          fi
        else
          echo "Tmux meta key is Ctrl + G"
        fi
      '';
    };
  };

  system.stateVersion = "25.05"; # DO NOT CHANGE
}
