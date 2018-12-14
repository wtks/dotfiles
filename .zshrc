#-------------------------------------------------------------------------
# Environment Variables
#-------------------------------------------------------------------------
export FZF_DEFAULT_OPTS="--extended --cycle --ansi --select-1 --reverse"
export FZF_COMPLETION_TRIGGER='**'
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
zplug "b4b4r07/zsh-vimode-visual", defer:3

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

#-------------------------------------------------------------------------
# Zsh Line Editor
#-------------------------------------------------------------------------
autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
left_down_prompt_preexec() {
    print -rn -- $terminfo[el]
}
add-zsh-hook preexec left_down_prompt_preexec

function zle-keymap-select zle-line-init zle-line-finish
{
    case $KEYMAP in
        main|viins)
            PROMPT_2="$fg[cyan][INSERT]$reset_color"
            ;;
        vicmd)
            PROMPT_2="$fg[white][NORMAL]$reset_color"
            ;;
        vivis|vivli)
            PROMPT_2="$fg[yellow][VISUAL]$reset_color"
            ;;
    esac

    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

bindkey -v
bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^J'  vi-cmd-mode
bindkey -M viins '^K'  kill-line
bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^P'  up-line-or-history
bindkey -M viins '^R'  history-incremental-pattern-search-backward
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^Y'  yank
bindkey -M vivis '^J'  vi-visual-exit

function select-history() {
    BUFFER=$(history -n -r 1 | fzf --no-sort --height 50% +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N select-history
bindkey '^r' select-history

#-------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------
setopt prompt_subst prompt_cr prompt_percent

function prompt_pwd() {
    setopt localoptions extendedglob

    local current_pwd="${PWD/#$HOME/~}"
    local ret_directory

    if [[ "$current_pwd" == (#m)[/~] ]]; then
        ret_directory="$MATCH"
        unset MATCH
    else
        ret_directory="${${${${(@j:/:M)${(@s:/:)current_pwd}##.#?}:h}%/}//\%/%%}/${${current_pwd:t}//\%/%%}"
    fi

    unset current_pwd

    print "$ret_directory"
}

function prompt_precmd() {
    # Check for untracked files or updated submodules since vcs_info doesn't.
    if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        fmt_branch=" %b%u%c${__PROMPT_SKWP_COLORS[4]}●%f"
    else
        fmt_branch=" %b%u%c"
    fi
    zstyle ':vcs_info:*:prompt:*' formats "${fmt_branch}"
    POWERLINE_PROMPT_PWD=$(prompt_pwd)
    vcs_info 'prompt'
}

function prompt_setup() {
    setopt LOCAL_OPTIONS
    unsetopt XTRACE KSH_ARRAYS

    autoload -Uz vcs_info

    add-zsh-hook precmd prompt_precmd

    # Use extended color pallete if available.
    if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
        __PROMPT_SKWP_COLORS=(
          "%F{81}"  # turquoise
          "%F{166}" # orange
          "%F{135}" # purple
          "%F{161}" # hotpink
          "%F{118}" # limegreen
        )
    else
        __PROMPT_SKWP_COLORS=(
          "%F{cyan}"
          "%F{yellow}"
          "%F{magenta}"
          "%F{red}"
          "%F{green}"
        )
    fi

    # Formats:
    # %b - branchname
    # %u - unstagedstr (see below)
    # %c - stagedstr (see below)
    # %a - action (e.g. rebase-i)
    # %R - repository path
    # %S - path in the repository
    # %n - user
    # %m - machine hostname

    local fmt_branch="${__PROMPT_SKWP_COLORS[2]}%b%f%u%c"
    local fmt_action="${__PROMPT_SKWP_COLORS[5]}%a%f"
    local fmt_unstaged="${__PROMPT_SKWP_COLORS[2]}●%f"
    local fmt_staged="${__PROMPT_SKWP_COLORS[5]}●%f"

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*:prompt:*' check-for-changes true
    zstyle ':vcs_info:*:prompt:*' unstagedstr   "${fmt_unstaged}"
    zstyle ':vcs_info:*:prompt:*' stagedstr     "${fmt_staged}"
    zstyle ':vcs_info:*:prompt:*' actionformats "${fmt_branch}${fmt_action}"
    zstyle ':vcs_info:*:prompt:*' formats       "${fmt_branch}"
    zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

    # Setup powerline style colouring
    POWERLINE_COLOR_BG_GRAY=%K{240}
    POWERLINE_COLOR_BG_LIGHT_GRAY=%K{240}
    POWERLINE_COLOR_BG_WHITE=%K{255}

    POWERLINE_COLOR_FG_GRAY=%F{240}
    POWERLINE_COLOR_FG_LIGHT_GRAY=%F{240}
    POWERLINE_COLOR_FG_WHITE=%F{255}

    POWERLINE_SEPARATOR=$'\uE0B0'
    POWERLINE_R_SEPARATOR=$'\uE0B2'

    POWERLINE_LEFT_A="%K{006}%F{015} "'${POWERLINE_PROMPT_PWD}'" %k%f%F{006}%K{blue}"$POWERLINE_SEPARATOR
    POWERLINE_LEFT_B="%k%f%F{015}%K{blue} "'${vcs_info_msg_0_}'" %k%f%F{blue}%K{black}"$POWERLINE_SEPARATOR
    POWERLINE_LEFT_C=" %k%f%F{015}%K{black}"" %k%f%F{black}"$POWERLINE_SEPARATOR"%f "

    PROMPT="%{$terminfo_down_sc"'${PROMPT_2}'"$terminfo[rc]%}"$POWERLINE_LEFT_A$POWERLINE_LEFT_B$POWERLINE_LEFT_C
    RPROMPT=$POWERLINE_COLOR_FG_WHITE$POWERLINE_R_SEPARATOR"%f%k"$POWERLINE_COLOR_BG_WHITE$POWERLINE_COLOR_FG_GRAY" %n@%m %f%k"
}

if [[ "$TERM" != linux ]]; then
    prompt_setup
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(direnv hook zsh)"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
