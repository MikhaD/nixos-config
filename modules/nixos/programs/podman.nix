{...}: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true; # creates "docker" alias for podman
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
