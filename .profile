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

if [ -d "$HOME/etc/bin" ] ; then
  path_prepend_if_absent "$HOME/etc/bin"
fi
if [ -d "$HOME/bin" ] ; then
  path_prepend_if_absent "$HOME/bin"
fi

export EDITOR=vim

# https://wiki.archlinux.org/index.php/GNOME_Keyring
if ! [ -e "$SSH_AUTH_SOCK" ] ; then
  SSH_AUTH_SOCK=""
fi
if [ -z "$SSH_AUTH_SOCK" ] ; then
  sockets="$(netstat -xl 2>&1 || echo)"
  SSH_AUTH_SOCK=$(echo "$sockets" | grep -o "/run/user/$UID/keyring.*/ssh$")
fi
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(echo "$sockets" | grep -o '/tmp/keyring-.*/ssh$')
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(echo "$sockets" | grep -o '/tmp/ssh-.*/agent.*$')
[ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK
