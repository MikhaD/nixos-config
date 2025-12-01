#!/usr/bin/env bash
VERSION="<REPLACED IN INSTALL PHASE>"

set -eo pipefail

if [[ -f $XDG_STATE_HOME/bash_history ]]; then
	HISTFILE="$XDG_STATE_HOME/bash_history"
else
	HISTFILE="${HISTFILE:-~/.bash_history}"
fi

case $1 in
	-h|--help)
	echo "usage: retcon [-h] [-r] [-v]"
	echo
	echo "Interactively remove entries from your bash history using fzf (starting from the end)."
	echo
	echo "options:"
	echo "  -h, --help    Show this help message and exit."
	echo "  -r, --reverse Display the history entries in reverse (most recent first)."
	echo "  -v, --version Show the version number and exit."
	echo
	echo "retcon version $VERSION"
	exit 0
	;;
	-v|--version)
	echo "retcon version $VERSION"
	exit 0
	;;
	-r|--reverse)
	LINES=$(nl -ba -w1 -s$'d\x1f' "$HISTFILE" | tac)
	;;
	"")
	LINES=$(nl -ba -w1 -s$'d\x1f' "$HISTFILE")
	;;
	*)
	echo "Unknown option: $1"
	echo "usage: retcon [-h] [-r] [-v]"
	exit 1
	;;
esac

CUTS=$(fzf --multi --delimiter='\x1f' --with-nth=2 <<< "$LINES" | cut -f1 -d $'\x1f')

[[ -z $CUTS ]] && exit 0

sed -i -e "$CUTS" "$HISTFILE"
TOTAL=$(wc -w <<< "$CUTS")
echo "Removed $TOTAL line$([[ $TOTAL -ne 1 ]] && echo s)"