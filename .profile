if [ -d "$HOME/etc/bin" ] ; then
  PATH="$HOME/etc/bin:$PATH"
fi
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

export EDITOR=vim
