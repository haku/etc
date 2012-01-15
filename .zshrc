[[ -r "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"
[[ $TERM == "xterm" ]] && tmux && exit
