{pkgs, ...}: {
  xdg = {
    enable = true;
    # portal.enable = true;
    # portal.extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
    mime.enable = true;
    mimeApps = {
      enable = true;
      # specify default applications for a given mime type
      # defaultApplications = {

      # };
    };

    # XDG Base directories: https://specifications.freedesktop.org/basedir-spec/latest
  };
}
