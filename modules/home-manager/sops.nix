{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  # sops.defaultSopsFile = ./../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  sops.secrets."config" = {
    sopsFile = ./../../secrets/ssh.yaml;
    path = "${config.home.homeDirectory}/.ssh/config";
  };
  home.packages = [
    pkgs.sops
  ];
}
