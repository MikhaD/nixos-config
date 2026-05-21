{inputs, ...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings =
      {
        "*" = {
          addKeysToAgent = "yes";
          identitiesOnly = true;
          forwardAgent = false;
          controlPersist = "no";
          controlMaster = "auto";
          controlPath = "~/.ssh/cm-%r@%h:%p";
        };
      }
      // inputs.secrets.ssh.config;
  };
}
