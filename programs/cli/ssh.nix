{ ... }:
{
  programs.ssh = {
    startAgent = true;
    # extraConfig = ''
    # '';
  };
#   programs.ssh = {
#     enable = true;
#   };
#   services.ssh-agent.enable = true;
}