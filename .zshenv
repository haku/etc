# == General ==

autoload -U compinit compinit

# == History ==

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt appendhistory

# == Other options ==

setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome
setopt autocd
setopt cdablevars
setopt interactivecomments
setopt nobanghist
setopt noclobber # prevents accidentally overwriting an existing file.
setopt SH_WORD_SPLIT # var are split into words when passed.
setopt nohup # do not kil background jobs on logout.
setopt nomatch # If a pattern for filename has no matches = error.
setopt PRINT_EXIT_VALUE
setopt LONG_LIST_JOBS

# == Extra prompt info ==

setopt prompt_subst
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

# == Aliases ==

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

