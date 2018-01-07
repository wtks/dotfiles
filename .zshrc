if [[ "$OSTYPE" == linux* ]]; then
    source ~/.zprofile
fi

#-------------------------------------------------------------------------
# Environment Variables
#-------------------------------------------------------------------------
export FZF_DEFAULT_OPTS="--extended --cycle --ansi --select-1 --reverse"
export EASY_ONE_FZF_OPTS="--no-sort --height 50%"
export EASY_ONE_REFFILE="$DOTPATH/easy-oneliner.txt"
export EASY_ONE_KEYBIND="^o"

#-------------------------------------------------------------------------
# Source zplug Plugin Manager
#-------------------------------------------------------------------------
source ~/.zplug/init.zsh

zplug "zplug/zplug"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "wtks/6ff4c9d7b37378f56e662029e0051cba", from:gist, as:command, use:color_demo
zplug "wtks/43b31e7bd88d934cd921dbcdd6e322cc", from:gist
zplug "supercrabtree/k"
zplug "rupa/z", use:"z.sh"
zplug "changyuheng/fz", defer:1
zplug "changyuheng/zsh-interactive-cd", on:"junegunn/fzf-bin"
zplug "b4b4r07/easy-oneliner"

case $OSTYPE in
    darwin*)
        zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*darwin*amd64*"
        ;;
    linux*)
        zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*linux*amd64*"
        ;;
esac

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    zplug install
fi

# load plugins
zplug load

# zsh-syntax-highlighting Settings
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

#-------------------------------------------------------------------------
# Theme
#-------------------------------------------------------------------------
autoload -Uz promptinit && promptinit
if [[ "$TERM" != linux ]]; then
    prompt powerlinekai
fi

#-------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------
alias dotfiles="cd $DOTPATH"

alias grep='grep --color=auto'
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias df='df -kh'
alias du='du -kh'
alias mkdir='mkdir -p'

# if ((${+commands['dircolors']})); then # なぜか動かない
if [[ -x `which dircolors` ]]; then
    # GNU Core Utilities
    if [[ -s "$HOME/.dir_colors" ]]; then
        eval "$(dircolors --sh "$HOME/.dir_colors")"
    else
        export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
    fi
    alias ls="ls --group-directories-first -F --color=auto"
else
    # BSD Core Utilities
    export CLICOLOR=1
    export LSCOLORS='exfxcxdxbxGxDxabagacad'
    alias ls="ls -FG"
fi

if [[ "$OSTYPE" == linux* ]]; then
    alias open='xdg-open'
fi

if [[ -x "`which nvim`" ]]; then
    alias vim=nvim
fi

#-------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------

function change-wine-arch() {
    if [ "$WINEARCH" = win32 ]; then
        unset WINEARCH WINEPREFIX
        echo 'Change WineArch from 32bit to 64bit.'
    else
        export WINEARCH=win32 WINEPREFIX=~/.wine32
        echo 'Change WineArch from 64bit to 32bit.'
    fi
}

#-------------------------------------------------------------------------
# Zsh History
#-------------------------------------------------------------------------

HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_NO_STORE
setopt HIST_VERIFY
setopt HIST_BEEP

function select-history() {
    BUFFER=$(history -n -r 1 | fzf --no-sort --height 50% +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N select-history
bindkey '^r' select-history
