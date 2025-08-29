{ ... }:
{
  nix = {
    settings.auto-optimise-store = true; # Automatically hard link identical files in the Nix store to save space
    # Automatically run nix store garbage collection once a week
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d"; # Remove old generations older than 30 days
    };
  };
}