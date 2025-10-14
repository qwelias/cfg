export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
export EDITOR=micro

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:ssh:*' hosts off
zstyle ':completion:*' menu select

setopt PROMPT_SUBST
source "$HOME/.config/zsh-prompt.sh"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zle_highlight+=(paste:none)

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
bindkey  "^[[A"   history-beginning-search-backward
bindkey  "^[OA"   history-beginning-search-backward
bindkey  "^[[B"   history-beginning-search-forward
bindkey  "^[OB"   history-beginning-search-forward
bindkey '^[[Z' reverse-menu-complete

WORDCHARS=${WORDCHARS//[\/.-]/}

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

alias sx='nsxiv -ao'

export NNN_OPTS='JAdeEHi'
export NNN_FCOLORS='0000d64d0000000000000000'
export NNN_FIFO='/tmp/nnn.fifo'
nn ()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="/tmp/nnn.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}

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

export PATH="$HOME/script:$HOME/.cargo/bin:$PATH"
