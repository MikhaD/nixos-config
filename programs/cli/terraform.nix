{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    terraform
  ];
  programs.bash.shellAliases = {
      tf = "terraform";
  };
  environment.sessionVariables = {
    CHECKPOINT_DISABLE = 1;                   # Prevent ~/.terraform.d/checkpoint_signature from being created
    TF_DATA_DIR = "$XDG_DATA_HOME/terraform"; # Removes .terraform.d/ from ~
    # TF_CLI_CONFIG_FILE = "$XDG_CONFIG_HOME/terraform/terraform.rc";
  };
}