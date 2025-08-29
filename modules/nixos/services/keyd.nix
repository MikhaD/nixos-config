{ ... }:
{
  # Run sudo keyd monitor to find the names of keys by pressing them
  # https://wiki.nixos.org/wiki/Keyd
  # https://man.archlinux.org/man/extra/keyd/keyd.1.en
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
	    # Activate caps layer when capslock is pressed
	    capslock = "layer(caps)";
	    # Map my extra mouse buttons to Alt, Ctrl and Shift
            f20 = "layer(f20)";
            f23 = "layer(f23)";
	    f24 = "layer(f24)";
	  };
	  # The caps layer emulates the S (Shift) modifier if there are no explicit mappings in the layer to be triggered
	  # No mappings in the layer means capslock becomes a shift key
	  "caps:S" = {};
	  "f20:A" = {};
	  "f23:C" = {};
	  "f24:S" = {};
	  control = {
	    capslock = "capslock";
	  };
        };
      };
    };
  };
}