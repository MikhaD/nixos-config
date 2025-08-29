{
  pkgs,
  inputs,
  details,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix

    ./../../modules/nixos/system/boot.nix
    ./../../modules/nixos/system/gc.nix
    ./../../modules/nixos/services/tlp.nix
    ./../../modules/nixos/services/sshd.nix
  ];

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;
    # firewall.allowedTCPPorts = [80 443];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit details;};
    users.${details.username} = {
      imports = [
        ./../../modules/home-manager/bash
        ./../../modules/home-manager/bat.nix
        ./../../modules/home-manager/lsd.nix
        ./../../modules/home-manager/tmux
        ./../../modules/home-manager/git.nix
        ./../../modules/home-manager/neovim.nix
        ./../../modules/home-manager/fastfetch.nix
        ./../../modules/home-manager/xdg.nix
      ];
      home = {
        username = details.username;
        homeDirectory = "/home/${details.username}";

        sessionVariables = {
          LESSHISTFILE = "$XDG_STATE_HOME/lesshst";
        };

        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "25.05";
      };
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

        if [ -f "$HOME/.bashrc" ]; then
          source "$HOME/.bashrc"
        fi
      '';
    };
  };

  services.getty.autologinUser = details.username;

  users.users.${details.username} = {
    isNormalUser = true;
    description = details.fullName;
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBADTzEP2l0wbHSrrOn5kOWegowI7jDCpwq5cEh3UdGkBLQFS6f+pux0hfUprp/oWQRYv1GZo1PkWtncxh5tFaJ3qqAH5AtyMY/2xtMasOzCiQ6lFoP5cIW0sit4gHD0xKp2U2QcUz/mG9HvsHUQEdOhUURA50KuSFL57lgAk0itPl5vPMg==" # Laptop
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBABcxOPbFuFeEKKo5ksqKvp9ABYNymdUAgEBcAu+lQOYDVzToR0pfroM5VYzIVrCpfA3yNqrykcwgXhhFVIOu/NCagAZ/cHxSY8z4n131q1OyqRpOQxkqTBOnOqmRvgl2DzcqwAt4fIfP/Cw+/z32mBr3W2cvhK0LSB1PFoy0NicBF2P7Q==" # Phone
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
