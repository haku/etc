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
zstyle ':completion:*' tag-order '! users' # listing all users takes ages.

# speed up git autocomplete
__git_files() {
  _wanted files expl 'local files' _files
}	

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

# == Colors ==

export CLICOLORS=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

solarized_green="\e[0;32m"
solarized_red="\e[0;31m"
solarized_blue="\e[0;34m"
solarized_yellow="\e[0;33m"

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

export PS1="$(print '%{\e[0;33m%}%n%{\e[0;34m%}@%{\e[0;33m%}%m%{\e[0m%}:%{\e[0;34m%}%~%{\e[0m%}')
$ "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%} ')"
export RPS1=$'$(vcs_info_wrapper)'

# == Keyboard ==

bindkey '^a' beginning-of-line # Home
bindkey '^e' end-of-line # End
bindkey '^R' history-incremental-search-backward
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# various fixes for HOME / END keys.
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
#bindkey "\e[5~" beginning-of-history
#bindkey "\e[6~" end-of-history
#bindkey "\e[7~" beginning-of-line
#bindkey "\e[8~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
#bindkey "\e[H" beginning-of-line
#bindkey "\e[F" end-of-line
# if this goes wrong again try here: https://wiki.archlinux.org/index.php/Zsh

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

# == Current directory ==

function chpwd {
  window_index=$(tmux display-message -p '#D' | sed 's/%//')
  tmux setenv "window_${window_index}_pwd" "$(pwd)"
  if [[ -t 1 ]] ; then print -Pn "\e]2;%~\a" ; fi
}

function zshexit {
  window_index=$(tmux display-message -p '#D' | sed 's/%//')
  tmux setenv -u "window_${window_index}_pwd"
}

# == Other options ==

REPORTTIME=1 # notify on slow commands

# == Any local changes? ==
[[ -r "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"

# == is ssh? ==
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=ssh;;
  esac
fi
if [ -n "$SUDO_USER" ] || [ -n "$SUDO_COMMAND" ]; then
  SESSION_TYPE=sudo
fi

# == always tmux. ==
export TERM="screen-256color"
[ -z "$SESSION_TYPE" ] && [[ -z "$TMUX" ]] && (tmux attach || tmux) && exit
