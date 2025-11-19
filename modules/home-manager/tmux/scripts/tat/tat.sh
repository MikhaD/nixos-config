__list_tmux_sessions_for_fzf() {
    for name in $(tmux ls | cut -d: -f1); do
        echo "$name: ($(tmux list-windows -t $name -F "#{window_name}" | paste -sd ',' | sed 's/,/, /g'))"
    done
}

tat() {
    local count=$(tmux ls | wc -l)
    [[ $count -eq 0 ]] && return 1
    if [[ -n $1 ]]; then
        if [[ $1 == "-n" || $1 == "--new" ]]; then
            tmux new-session -d -t "$2"
            shift
        fi
        if tmux has-session -t $1 &> /dev/null; then
            if [[ -z $TMUX ]]; then
                tmux attach-session -t $1 &> /dev/null
            else
                tmux switch-client -t $1 &> /dev/null
            fi
            return $?
        else
            return 1
        fi
    fi
    if [[ $count -eq 1 ]]; then
        if [[ -z $TMUX ]]; then
            tmux attach-session
        fi
        return 0
        else
        if [[ -z $TMUX ]]; then
            local session=$(__list_tmux_sessions_for_fzf | fzf --info-command='echo -e "$FZF_INFO Select Tmux Session"')
            if [[ -z $session ]]; then
                return 1
            fi
            tmux attach-session -t "${session%%:*}"
        else
            tmux choose-tree
        fi
    fi
}