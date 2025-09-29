# == Resets ==

bindkey -e

# == History ==

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
unsetopt BANG_HIST
unsetopt SHARE_HISTORY

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "OA" history-beginning-search-backward-end
bindkey "OB" history-beginning-search-forward-end

# == Auto-complete ==

zmodload zsh/complist
autoload -Uz compinit
compinit
unsetopt completealiases

zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=94=91"
zstyle ':completion:*:descriptions' format '%U%d%u'
zstyle ':completion:*:warnings' format 'No matches for: %B%d%b'
zstyle ':completion:*' menu select=2 # show menu when at least 2 options.
zstyle ':completion::complete:cd::' tag-order '! users' - # do not auto complete user names
zstyle ':completion:*' tag-order '! users' # listing all users takes ages.

# here for ref for now
#zstyle ':completion:*:(ssh|scp|rsync):*' hosts off
#zstyle ':completion:*:(ssh|scp|rsync):*' config on
#zstyle ':completion:*:*:(ssh|scp|rsync):*:*' known-hosts-files off

# https://serverfault.com/questions/170346/how-to-edit-command-completion-for-ssh-on-zsh/170481#17048
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:(ssh|scp|rsync):*' hosts $h
fi
unset h


# speed up git autocomplete
__git_files() {
  _wanted files expl 'local files' _files
}	

# use + or = key to accept multiple autocompletes
bindkey -M menuselect "+" accept-and-menu-complete
bindkey -M menuselect "=" accept-and-menu-complete

# show waiting dots.
expand-or-complete-with-dots() {
  echo -n "\e[1;34m.....\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# == Colors ==

export CLICOLORS=1

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

ps_nix() {
  [ -z "$IN_NIX_SHELL" ] && return
  echo " \e[1;95mnix-shell\e[0m"
}
ps_timestamp() {
  # Colours https://en.wikipedia.org/wiki/ANSI_escape_code#3/4_bit
  echo -n "\e[0;34m$(date '+%Y%m%d-%H%M%S')\e[0m"
}

# https://stackoverflow.com/questions/4842424
export PS1="$(print "%{\e[0;93m%}%n%{\e[0;94m%}@%{\e[0;93m%}%m%{\e[0;94m%}:%{\e[1;96m%}%~%{\e[0m%}\$(ps_nix)  \$(ps_timestamp)")
$ "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%} ')"
export RPS1=$'$(vcs_info_wrapper)'

# == Keyboard ==
# run `bindkey` to list all.

bindkey '^a' beginning-of-line # Home
bindkey '^e' end-of-line # End
bindkey '^R' history-incremental-search-backward
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# alt + left/right
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# ctrl+u deletes left
bindkey \^U backward-kill-line

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

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    kill -9 %+
    zle redisplay
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# == Current directory ==

# disabled ssh split

#function chpwd {
#  if [ -n "$TMUX" ] ; then
#    window_index=$(tmux display-message -p '#D' | sed 's/%//')
#    tmux setenv "window_${window_index}_pwd" "$(pwd)"
#  fi
#  if [[ -t 1 ]] ; then print -Pn "\e]2;%~\a" ; fi
#}

#function zshexit {
#  if [ -n "$TMUX" ] ; then
#    window_index=$(tmux display-message -p '#D' | sed 's/%//')
#    tmux setenv -u "window_${window_index}_pwd"
#  fi
#}

# == Other options ==

REPORTTIME=1 # notify on slow commands

# == Any local changes? ==

[[ -r "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"

# == is ssh or sudo? ==

if [ -n "$IN_NIX_SHELL" ]; then
  SESSION_TYPE=nixshell
fi

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

if [ -z "$SESSION_TYPE" ] && [ -z "$TMUX" ] && which tmux > /dev/null 2>&1 ; then
  #export TERM="screen-256color"
  if tmux server-info > /dev/null 2>&1 ; then
    exec tmux attach
  else
    exec tmux
  fi
else
  check-authorized-keys
fi
