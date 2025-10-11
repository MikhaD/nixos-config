{details, ...}: {
  services.caddy = {
    enable = true;
    # acceptTerms = true;
    # email = details.email;
    virtualHosts."http://*" = {
      root = "/var/www/rabbithole-presentation/dist";
      extraConfig = ''
        try_files {path} /index.html
        file_server
        encoding gzip
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
# location context: where to find the files
# access_log: file to store access logs

