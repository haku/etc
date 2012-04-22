# == History ==

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

setopt APPENDHISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_VERIFY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt NOBANGHIST

# == Auto-complete ==

autoload -Uz compinit
compinit

setopt COMPLETEALIASES

zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ':completion:*:descriptions' format '%U%d%u'
zstyle ':completion:*:warnings' format 'No matches for: %B%d%b'
zstyle ':completion:*' menu select=2 # show menu when at least 2 options.
zstyle ':completion::complete:cd::' tag-order '! users' - # do not auto complete user names

# show waiting dots.
expand-or-complete-with-dots() {
  echo -n "\e[1;34m.....\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# == Corrections ==

#setopt CORRECTALL

# == Extra prompt info ==

setopt PROMPT_SUBST
autoload -Uz vcs_info

vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "${vcs_info_msg_0_}$del"
  fi
}

zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}]%f'
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

# == Prompt config ==

export PS1="$(print '%{\e[1;34m%}%n%{\e[0;34m@\e[1;34m%}%m%{\e[0m:\e[0;34m%}%~%{\e[0m%}')
$ "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%} ')"
#export RPS1="$(print '%{\e[0;32m%}[%?]%{\e[0m%}')"
export RPS1=$'$(vcs_info_wrapper)'

# == Keyboard ==

bindkey '^a' beginning-of-line # Home
bindkey '^e' end-of-line # End
bindkey '^R' history-incremental-search-backward
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

bindkey '^[[A' up-line-or-history   # Fix cursor position on history recall
bindkey '^[[B' down-line-or-history # as on Debian these default to vi-*.

# == Aliases ==

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# ==Helpers ==

# Alt-S inserts "sudo " at the start of line.
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# == tmp config helper ==

export ZSH_TMP="/tmp/$USER/"
mkdir -p $ZSH_TMP
chmod 700 $ZSH_TMP

# == Current directory ==

export ZSH_CURRENT_PATH="$ZSH_TMP/.zshpwd"

function chpwd {
  echo $(pwd) >! $ZSH_CURRENT_PATH
  if [[ -t 1 ]] ; then print -Pn "\e]2;%~\a" ; fi
}

if [[ -f $ZSH_CURRENT_PATH ]]; then
  cd "$(cat $ZSH_CURRENT_PATH)"
fi

# == Other options ==

REPORTTIME=1 # notify on slow commands

# == Any local changes? ==
[[ -r "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"

# == always tmux. ==
[[ $TERM == "xterm" ]] && tmux && exit
