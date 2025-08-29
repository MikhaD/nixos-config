{...}: {
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true;
    # https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/powermanagement.html
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      # Keep discrete GPU running at all times. Improves performance, reduces battery life
      sync.enable = false;
      # Only enable discrete GPU when needed, optimizing for power consumption (Need to set game's launch options in steam to nvidia-offload %command% to run with nvidia GPU)
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Bus IDs determined by running lspci | grep " VGA "
      # Integrated GPU
      intelBusId = "PCI:0@0:2:0";
      # Discrete GPU
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
}
