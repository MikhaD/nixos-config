{...}: {
  services.vaultwarden = {
    enable = false;
    #backupDir = "/var/lib/vaultwarden/backup";
    config = {
      DOMAIN = "https://bitwarden.example.com";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
      SMTP_FROM = "admin@bitwarden.example.com";
      SMTP_FROM_NAME = "example.com Bitwarden server";
    };
  };
  #services.nginx.virtualHosts."bitwarden.example.com" = {
  #  enableACME = true;
  #  forceSSL = true;
  #  locations."/" = {
  #      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
  #  };
  #};
}