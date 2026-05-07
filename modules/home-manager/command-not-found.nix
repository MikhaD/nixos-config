# Custom made replacement for the command-not-found package, which requires nix channels to work.
# The suggested alternative for flake based configurations is to use nix-index, but this is very slow to run on demand.
# This module uses nix-index (nix-locate) once to build a package to command mapping file in the nix store, only running
# again whenever the nix-index database is updated.
# This mapping file is read by awk when the command_not_found handle is triggered, producing output in the same format
# as the original command-not-found package, but without the channel dependency and with much faster lookup times.
{
  inputs,
  pkgs,
  ...
}: let
  nix-index-with-db = inputs.nix-index-database.packages.${pkgs.stdenv.system}.nix-index-with-db;
  # Build a tab-separated cmd->package index as a nix derivation so it is computed once and cached in the store
  binIndex = pkgs.runCommand "nix-command-index" {} ''
    ${nix-index-with-db}/bin/nix-locate --no-group --type x --type s --at-root "/bin/" 2>/dev/null \
      | ${pkgs.gawk}/bin/awk '{
          # $1 is the first field: the package attribute e.g. "inkscape.out". gsub removes the ".out" suffix to get the package name "inkscape"
          pkg = $1; gsub(/\.out$/, "", pkg)
          # $NF is the last field (NF = Number of Fields): the file path e.g. "/nix/store/.../bin/inkscape". The sub removes the leading path to get just the command name "inkscape"
          cmd = $NF; sub(/.*\//, "", cmd)
          print cmd "\t" pkg
        }' \
      | sort -u > $out
  '';
in {
  programs.bash.initExtra = ''
    command_not_found_handle() {
      local cmd=$1
      local -a packages
      mapfile -t packages < <(
        awk -F'\t' -v cmd="$cmd" '$1 == cmd { print $2 }' "${binIndex}" 2>/dev/null | sort -u
      )
      if [ ''${#packages[@]} -eq 0 ]; then
        echo "$cmd: command not found" >&2
      elif [ ''${#packages[@]} -eq 1 ]; then
        echo "The program '$cmd' is not in your PATH. It is provided by ''${packages[0]}'." >&2
        echo "You can make it available in an ephemeral shell by typing:" >&2
        echo "  nix-shell -p ''${packages[0]}" >&2
      else
        echo "The program '$cmd' is not in your PATH. It is provided by several packages." >&2
        echo "You can make it available in an ephemeral shell by typing one of the following:" >&2
        for pkg in "''${packages[@]}"; do
          echo "  nix-shell -p $pkg" >&2
        done
      fi
      return 127
    }
  '';
}
