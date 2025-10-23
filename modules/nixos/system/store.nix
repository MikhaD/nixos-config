{...}: {
  nix = {
    optimise.automatic = true; # Automatically hard link existing identical files in the Nix store to save space
    settings.auto-optimise-store = true; # Automatically hard link new identical files in the Nix store to save space
    # Automatically run nix store garbage collection once a week. Disabled because I would prefer to run it manually via nh
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 14d"; # Remove old generations older than 14 days
    # };
  };
}
