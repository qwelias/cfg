ffc () {
	echo -n "%F{$1}$2%f"
}

ffcb () {
	echo -n "%F{$1}%B$2%b%f"
}

get_git () {
	if [[ $HOME == $PWD ]]
	then echo git --git-dir=$HOME/cfg/ --work-tree=$HOME
	else echo git
	fi
}

git_branch () {
  git=$(get_git)
  ref=$(`echo command $git symbolic-ref HEAD` 2> /dev/null) || \
  ref=$(`echo command $git rev-parse --short HEAD` 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

git_status() {
  git=$(get_git)
  _STATUS=""

  # check status of files
  _INDEX=$(`echo command $git status --porcelain` 2> /dev/null)
  if [[ -n "$_INDEX" ]]; then
    if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
      _STATUS="$_STATUS$(ffcb green ●)"
    fi
    if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
      _STATUS="$_STATUS$(ffcb yellow ●)"
    fi
    if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
      _STATUS="$_STATUS$(ffcb red ●)"
    fi
    if $(echo "$_INDEX" | command grep -q '^UU '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    _STATUS="$_STATUS$(ffcb green ✓)"
  fi

  # check status of local repository
  _INDEX=$(`echo command $git status --porcelain -b` 2> /dev/null)
  if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then
    _STATUS="$_STATUS$(ffc cyan ▴)"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*behind'); then
    _STATUS="$_STATUS$(ffc magenta ▾)"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if $(`echo command $git rev-parse --verify refs/stash` &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $_STATUS
}

git_prompt () {
  local _branch=$(git_branch)
  local _status=$(git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$(ffcb cyan $_branch)"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
  fi
  echo $_result
}

_PATH="$(ffcb blue %~)"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="$(ffcb red %n)$(ffcb black @%m)"
  _CARET="$(ffcb red \#)"
else
  _USERNAME="$(ffcb green %n)$(ffcb black @%m)"
  _CARET="$(ffcb green \$)"
fi


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

	echo " $(ffcb red $code)"
}

node_version () {
	local _vv=$(node --version) || return
	echo "$(ffcb green ⬡) $_vv"
}

prompt_header () {
	local code_info="$(exit_info)"
    local left="$_USERNAME $_PATH $(git_prompt)"
    local right="$(node_version) [%*]$code_info"

    local spaces=$(get_space $left $right)

    echo "$left$spaces$right"
}

PROMPT='
$(prompt_header)
$_CARET '
