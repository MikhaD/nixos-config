# Need to use non HM version for now because I don't want to clobber my existing ssh config or publish it to github
{...}: {
  programs.ssh = {
    startAgent = true;
    # extraConfig = ''
    # '';
  };

  # HOME MANAGER VERSION
  # programs.ssh = {
  #   enable = true;
  #   addKeysToAgent = true;
  # };
  # services.ssh-agent.enable = true;
}
