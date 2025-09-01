{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    terraform
  ];
  programs.bash.shellAliases = {
    tf = "terraform";
  };
  home.sessionVariables = {
    CHECKPOINT_DISABLE = 1; # Prevent ~/.terraform.d/checkpoint_signature from being created
    TF_DATA_DIR = "${config.xdg.dataHome}/terraform"; # Removes .terraform.d/ from ~
    # TF_CLI_CONFIG_FILE = "${config.xdg.configHome}/terraform/terraform.rc";
  };
}
