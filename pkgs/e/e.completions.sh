_e_completions() {
	if [[ $COMP_CWORD -gt 2 || $COMP_CWORD -lt 1 ]]; then
		return
	fi
	local MATCH_VARS=$(printenv | cut -d= -f1 | grep -i "^${COMP_WORDS[COMP_CWORD]}.*")
	if [[ $COMP_CWORD -eq 1 ]]; then
		COMPREPLY=($(compgen -W "--help --quiet --version" -- "${COMP_WORDS[1]}"))
		COMPREPLY+=($MATCH_VARS)
	elif [[ $COMP_CWORD -eq 2 && (${COMP_WORDS[1]} == "-q" || ${COMP_WORDS[1]} == "--quiet") ]]; then
		COMPREPLY=($MATCH_VARS)
	fi
}

complete -F _e_completions e