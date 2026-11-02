{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ngrok
  ];
  xdg.configFile."ngrok/ngrok.yml".text = builtins.toJSON {
    version = "3";
    agent = {
      authtoken = inputs.secrets.ngrok.authtoken;
    };
    endpoints = [
      {
        name = "http";
        url = "quicklysign.ngrok.io";
        upstream = {
          url = "8484";
        };
      }
    ];
  };
}
