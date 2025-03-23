export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:ssh:*' hosts off
zstyle ':completion:*' menu select

setopt PROMPT_SUBST
source "$HOME/.config/zsh-prompt.sh"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

setopt globdots
setopt complete_aliases

bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

WORDCHARS='*?_-.[]~=&;:!#$%^(){}<>/ $\n'
autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style unspecified

export EDITOR='micro'
export GIT_EDITOR='micro'
export SYSTEMD_EDITOR='micro'

alias tab='sed "s/^/  /"'

alias cfg='git --git-dir=$HOME/cfg/ --work-tree=$HOME'
compdef cfg='git'

alias tigc='GIT_DIR=$HOME/cfg/ GIT_WORK_TREE=$HOME tig'
compdef tigc='tig'

alias ctrlc='xclip -selection clipboard -i'
alias ctrlv='xclip -selection clipboard -o'

# if [ -e /etc/profile.d/vte.sh ]; then
#     . /etc/profile.d/vte.sh
# fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

ZSH_CACHE_DIR=$HOME/.cache/zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source /usr/share/nvm/init-nvm.sh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="$HOME/.cargo/bin:$PATH"
