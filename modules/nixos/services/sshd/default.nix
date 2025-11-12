{
  details,
  lib,
  ...
}: let
  keyFiles = lib.filesystem.listFilesRecursive ./ssh-public-keys;
in {
  imports = [
    ./../../system/user.nix
  ];
  services.openssh = {
    enable = true;
    ports = [1999];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [details.username];
    };
  };
  services.fail2ban = {
    enable = true;
    bantime = "1h";
    bantime-increment.enable = true;
  };
  default-user.extra = {
    openssh.authorizedKeys.keyFiles = keyFiles;
  };
}
