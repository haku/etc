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
path_prepend() {
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
  path_prepend "$HOME/etc/bin"
fi
if [ -d "$HOME/bin" ] ; then
  path_prepend "$HOME/bin"
fi

export EDITOR=vim

# https://wiki.archlinux.org/index.php/GNOME_Keyring
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(netstat -xl | grep -o '/tmp/keyring-.*/ssh$')
[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(netstat -xl | grep -o '/tmp/ssh-.*/agent.*$')
[ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK

if [ "$ZSH_NAME" = "zsh" ] && [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
fi
