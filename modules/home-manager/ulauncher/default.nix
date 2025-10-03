{
  inputs,
  pkgs,
  ...
}: let
  iconPath = "${inputs.ulauncher6.packages.${pkgs.system}.default}/share/ulauncher/icons";
in {
  imports = [./ulauncher.nix];
  ulauncher = {
    enable = true;
    daemonlessMode = true;
    shortcuts = {
      googlesearch = {
        query = "https://google.com/search?q=%s";
        icon = "${iconPath}/google-search.png";
        includeInFallbackForSearchResults = true;
        keyword = "g";
        name = "Google Search";
      };
      stackoverflow = {
        query = "https://stackoverflow.com/search?q=%s";
        icon = "${iconPath}/stackoverflow.svg";
        includeInFallbackForSearchResults = true;
        keyword = "so";
        name = "Stack Overflow";
      };
      wikipedia = {
        query = "https://en.wikipedia.org/wiki/%s";
        icon = "${iconPath}/wikipedia.png";
        includeInFallbackForSearchResults = true;
        keyword = "wiki";
        name = "Wikipedia";
      };
      homemanager = {
        query = "https://home-manager-options.extranix.com/?query=%s&release=master";
        icon = ./icons/homemanager.svg;
        includeInFallbackForSearchResults = true;
        keyword = "hm";
        name = "Home Manager Search";
      };
      nixpkgs = {
        query = "https://search.nixos.org/packages?channel=unstable&query=%s";
        icon = ./icons/nixpkgs.svg;
        includeInFallbackForSearchResults = true;
        keyword = "nix";
        name = "Nix Packages Search";
      };
      noogle = {
        query = "https://noogle.dev/q?term=%s";
        icon = ./icons/noogle.svg;
        includeInFallbackForSearchResults = true;
        keyword = "noogle";
        name = "Noogle Search";
      };
    };
  };
}
