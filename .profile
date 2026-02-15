path_has() {
  if echo "$PATH" | tr ':' '\n' | grep -x -q "$1" ; then
    return 0
  else
    return 1
  fi
}
path_append() {
  if ! path_has "$1" ; then
    PATH="$PATH:$1"
  fi
}
path_prepend_if_absent() {
  if ! path_has "$1" ; then
    PATH="$1:$PATH"
  fi
}
path_prepend_force() {
  if path_has "$1" ; then
    PATH="${PATH//":$1"/}"
    PATH="${PATH//"$1:"/}"
  fi
  PATH="$1:$PATH"
}
path_tidy() {
  PATH="$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')"
}

[ -d "$HOME/etc/bin" ] && path_prepend_if_absent "$HOME/etc/bin"
[ -d "$HOME/bin"     ] && path_prepend_if_absent "$HOME/bin"

[ -e "$HOME/etc/dircolors" ] && eval "$(dircolors "$HOME/etc/dircolors")"

scg="$HOME/cte/scg/scg"
if [ -e "$scg" ] ; then
  . "$scg"
fi

export EDITOR="vim -p"

# https://wiki.archlinux.org/index.php/GNOME_Keyring
if ! [ -e "$SSH_AUTH_SOCK" ] ; then
  SSH_AUTH_SOCK=""
fi
[ -z "$SSH_AUTH_SOCK" ] && sockets="$(ss -xl 2>&1 || echo)"
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(echo "$sockets" | grep -o "$HOME/.ssh/agent/[^ ]*" | head -n 1)
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(echo "$sockets" | grep -o "/run/user/$UID/ssh-agent" | head -n 1)
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(echo "$sockets" | grep -o '/tmp/ssh-[^/]*/agent[^ ]*' | head -n 1)
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(echo "$sockets" | grep -o "/run/user/$UID/keyring.*/ssh$")
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(echo "$sockets" | grep -o '/tmp/keyring-.*/ssh$')
[ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK

_lp="$HOME/.profile-local"
[ -e "$_lp" ] && . "$_lp"
unset _lp
