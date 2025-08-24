{ ... }:
{
  programs.ssh = {
    startAgent = true;
    # Contents of ssh config file would go here
    # extraConfig = ''
    # '';
  };
}