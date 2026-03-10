{...}: {
  default-user.extraGroups = ["podman" "docker"];

  virtualisation = {
    containers.enable = true;
    docker.enable = true;
    podman = {
      enable = true;
      # dockerCompat = true; # creates "docker" alias for podman
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
