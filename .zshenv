# == Other options ==

setopt MULTIOS # pipe to multiple outputs.
setopt EXTENDEDGLOB # e.g. cp ^*.(tar|bz2|gz)
setopt RM_STAR_WAIT
setopt AUTOPUSHD
setopt PUSHDMINUS
setopt PUSHDSILENT
setopt PUSHDTOHOME
setopt AUTOCD
setopt CDABLEVARS
setopt INTERACTIVECOMMENTS
setopt NOCLOBBER # prevents accidentally overwriting an existing file.
setopt SH_WORD_SPLIT # var are split into words when passed.
setopt NOHUP # do not kill background jobs on logout.
setopt NOMATCH # If a pattern for filename has no matches = error.
setopt PRINT_EXIT_VALUE
setopt LONG_LIST_JOBS

if [ -d "$HOME/.rvm/bin" ] ; then
  PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi
