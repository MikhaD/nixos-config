{
  inputs,
  pkgs,
  ...
}: let
  # textual 8.x removed Select.BLANK; it now resolves to False from Widget base class.
  # Replace with Select.NULL which is the correct "no selection" sentinel in textual 8.x.
  jiratui = pkgs.jiratui.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace src/jiratui/widgets/work_item_details/details.py \
          --replace-fail "Select.BLANK" "Select.NULL"
      '';
  });
in {
  home.packages = [
    jiratui
  ];
  xdg.configFile."jiratui/config.yaml".text = builtins.toJSON {
    jira_api_username = inputs.secrets.jira.username;
    jira_api_token = inputs.secrets.jira.api_token;
    jira_api_base_url = inputs.secrets.jira.api_base_url;
  };
}
