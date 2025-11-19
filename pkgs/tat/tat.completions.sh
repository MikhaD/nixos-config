_tat_completions() {
	if [[ $COMP_CWORD -gt 2 || $COMP_CWORD -lt 1 ]]; then
		return
	fi
    local MATCH_SESSIONS=$(tmux ls 2> /dev/null | cut -d: -f1 | grep -i "^${COMP_WORDS[COMP_CWORD]}.*")
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "--help --new --version" -- "${COMP_WORDS[1]}"))
        COMPREPLY+=($MATCH_SESSIONS)
    elif [[ $COMP_CWORD -eq 2 && (${COMP_WORDS[1]} == "-n" || ${COMP_WORDS[1]} == "--new") ]]; then
        COMPREPLY=($MATCH_SESSIONS)
    fi
}

complete -F _tat_completions tat