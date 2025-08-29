{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition; # Use firefox dev edition
    # List of policies: https://mozilla.github.io/policy-templates/
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DefaultDownloadDirectory = "\${HOME}/Desktop";
      DisableFirefoxStudies = true;
      DisableFormHistory = true; # Disable saving information on web forms and the search bar.
      DisablePocket = true;
      DisableTelemetry = true;
      # might prevent dns sink from working
      # DNSOverHTTPS = {
      #   Enabled = true;
      # };
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
      };
      HardwareAcceleration = true;
      HttpsOnlyMode = "enabled";
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      PromptForDownloadLocation = true;
      # SearchEngines = {
      #   Default = "DuckDuckGo";
      #   PreventInstalls = true; # Force me to add search engines declaratively
      #   Add = [
      #     {};
      #   ];
      # };
      SkipTermsOfUse = true;
    };
  };
}