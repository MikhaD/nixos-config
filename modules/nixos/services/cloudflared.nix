{
  inputs,
  pkgs,
  ...
}: {
  services.cloudflared = {
    enable = true;
    tunnels = inputs.secrets.cloudflared.tunnels;
  };
  home-config.packages = with pkgs; [
    cloudflared
  ];
}
# # Imperitive steps
# - Generate .cloudflared/cert.pem: `cloudflared login`
# - Create tunnel: `cloudflared tunnel create <tunnel name>`
# - Rename tunnel credentials file in ~/.cloudflared
# - Route DNS: `cloudflared tunnel route dns <tunnel name> <subdomain.domain>`

