{...}: {
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      dns = {
        bind_host = "0.0.0.0";
        port = 53;
      };
      http = {
        address = "0.0.0.0:3001";
      };
    };
  };

  # adguardhome gets a dynamic GID that doesn't exist in the build sandbox,
  # causing logrotate's build-time config check to fail
  services.logrotate.checkConfig = false;
}
