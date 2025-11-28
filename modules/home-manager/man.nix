{
  lib,
  pkgs,
  ...
}: {
  programs.man.enable = true;
  home.sessionVariables = {
    # Use bat as the man pages pager (`--plain` disables decorations like line numbers, git markers & file name header)
    # col -bx is used to remove backspaces that are used for bold/underline
    MANPAGER = "sh -c 'col -bx | ${lib.getExe pkgs.bat} --language man --plain'";
    MANROFFOPT = "-c"; # Tell man to produce cleaner output (i.e. don't use bold/underline)
  };
}
