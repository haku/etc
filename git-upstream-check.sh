# change which remote is checked: git branch --set-upstream-to=...
_git_upstream_check() {
  local upstream
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
  if [ -z "$upstream" ] && [ -e .git ] ; then
    print -P "%F{11}  upstream not set%f"
    return
  fi

  local remote=${upstream%%/*}
  local url
  url=$(git remote get-url "$remote" 2>/dev/null) || return
  [[ "$url" == git@* ]] || return

  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return
  local rel="${root#/}"
  local cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/git-upstream-check"
  local stamp="$cache_root/$rel"

  local cache_dir="${stamp:h}"
  [ -e "$cache_dir" ] || mkdir -p "$cache_dir"

  local last=0
  [[ -e $stamp ]] && last=$(stat --format "%Y" "$stamp")

  if (( $(date +%s) - last > 3600 )); then
    touch "$stamp"
    print -P "%F{11}  fetching upstream %B${remote}%b ...%f"
    git fetch --quiet --no-tags "$remote"
  fi

  local behind=$(git rev-list --count HEAD.."$upstream")
  if (( behind > 0 )); then
    local branch=$(git symbolic-ref --quiet --short HEAD)
    print -P "%F{11}  %B${branch}%b is behind %B${upstream}%b by %B${behind}%b commit(s)%f"
  fi
}

autoload -Uz add-zsh-hook

_git_upstream_check_once() {
  add-zsh-hook -d precmd _git_upstream_check_once
  _git_upstream_check
}

add-zsh-hook precmd _git_upstream_check_once
add-zsh-hook chpwd _git_upstream_check
