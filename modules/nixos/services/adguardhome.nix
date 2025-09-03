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
}
