# oh-my-zsh Bureau Theme

### NVM

ZSH_THEME_NVM_PROMPT_PREFIX="%{$fg_bold[green]%}%B⬡%b%{$reset_color%} "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

### Git [master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

get_git () {
	if [[ $HOME == $PWD ]]
	then echo git --git-dir=$HOME/cfg/ --work-tree=$HOME
	else echo git
	fi
}

bureau_git_branch () {
  git=$(get_git)
  ref=$(`echo command $git symbolic-ref HEAD` 2> /dev/null) || \
  ref=$(`echo command $git rev-parse --short HEAD` 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status() {
  git=$(get_git)
  _STATUS=""

  # check status of files
  _INDEX=$(`echo command $git status --porcelain` 2> /dev/null)
  if [[ -n "$_INDEX" ]]; then
    if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if $(echo "$_INDEX" | command grep -q '^UU '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # check status of local repository
  _INDEX=$(`echo command $git status --porcelain -b` 2> /dev/null)
  if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*behind'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if $(`echo command $git rev-parse --verify refs/stash` &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $_STATUS
}

bureau_git_prompt () {
  local _branch=$(bureau_git_branch)
  local _status=$(bureau_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}

qwe_prompt () {
    local package_version
    local result

    package_version=$((cat package.json | gawk 'match($0, /"version":\s?"(.+?)"/, a) {print a[1]}') 2> /dev/null)
    if [[ "${package_version}x" != "x" ]]; then
        if [[ "${result}x" != "x" ]]; then
            result+=" $package_version"
        else
            result+=$package_version
        fi
    fi

    [[ "${result}x" != "x" ]] && echo "($result)"
}

_PATH="%{$fg_bold[blue]%}%~%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$fg_bold[green]%}%n"
  _LIBERTY="%{$fg[green]%}$"
fi
_USERNAME="$_USERNAME%{$reset_color%}%{$fg_bold[grey]%}@%m%{$reset_color%}"
_LIBERTY="$_LIBERTY%{$reset_color%}"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}}
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))

  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}

exit_info () {
	local code="$?"
	[ $code -eq 0 ] && return

	echo " %{$fg_bold[red]%}$code"
}

bureau_prompt_header () {
	local code_info="$(exit_info)"
    local left="$_USERNAME $_PATH $(bureau_git_prompt) $(qwe_prompt)"
    local right="$(nvm_prompt_info) [%*]$code_info"

    local spaces=$(get_space $left $right)

    echo "$left$spaces$right"
}

PROMPT='
$(bureau_prompt_header)
$_LIBERTY '
