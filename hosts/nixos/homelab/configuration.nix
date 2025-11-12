{hostname, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./../../../modules/home-manager

    ./../../../modules/nixos/services/adguardhome.nix
    # ./../../../modules/nixos/services/caddy
    # ./../../../modules/nixos/services/cloudflared.nix
    ./../../../modules/nixos/services/sshd
    ./../../../modules/nixos/services/tlp.nix
    # ./../../../modules/nixos/services/vaultwarden.nix
    # ./../../../modules/nixos/services/nextcloud.nix

    ./../../../modules/nixos/system/boot.nix
    ./../../../modules/nixos/system/store.nix
    ./../../../modules/nixos/system/user.nix

    ./../../../modules/nixos/programs/nix-ld.nix
  ];

  # networking.firewall.allowedTCPPorts = [80 443];

  default-user.enable = true;
  default-user.autoLogin = true;

  home-config = {
    enable = true;
    modules = [
      ./../../../modules/home-manager/bash
      ./../../../modules/home-manager/bat.nix
      ./../../../modules/home-manager/fastfetch.nix
      ./../../../modules/home-manager/fzf.nix
      ./../../../modules/home-manager/git.nix
      ./../../../modules/home-manager/grep.nix
      ./../../../modules/home-manager/lsd.nix
      ./../../../modules/home-manager/neovim.nix
      ./../../../modules/home-manager/nh
      ./../../../modules/home-manager/nodejs.nix
      ./../../../modules/home-manager/python.nix
      ./../../../modules/home-manager/speedtest-cli.nix
      ./../../../modules/home-manager/ssh.nix
      ./../../../modules/home-manager/tmux
      ./../../../modules/home-manager/tree.nix
    ];
    extra = {
      tmux = {
        prefix = "C-g";
        prompt = {
          background = "#99CCE6";
          info.host.enable = false;
        };
      };

      # Start new tmux session on login if not already inside tmux, or attach to existing
      programs.bash.profileExtra = ''
        if [ -z "$TMUX" ]; then
          if ! tmux has-session -t "${hostname}" 2>/dev/null; then
            tmux new-session -s "${hostname}"
          else
           tmux attach-session -t "${hostname}"
          fi
        else
          echo "Tmux meta key is Ctrl + G"
        fi
      '';
    };
  };

  system.stateVersion = "25.05"; # DO NOT CHANGE
}
