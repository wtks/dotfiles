if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

if [[ -x "`which nvim`" ]]; then
    export EDITOR='nvim'
    export VISUAL='nvim'
else
    export EDITOR='vi'
    export VISUAL='vi'
fi

export PAGER='less'
export DOTPATH="$(cat $HOME/.dotpath)"
export LANG='en_US.UTF-8'

#
# Paths
#

# Ensure  ]]h arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  "$HOME/bin"
  $path
)

fpath=(
  "$DOTPATH/functions"
  $fpath
)
#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="$(mktemp -d)"
fi

TMPPREFIX="${TMPDIR%/}/zsh"


#
# rbenv
#

if [ -e "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

#
# pyenv
#

if [ -e "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

#
# Golang
#

if [ -x "`which go`"  ]; then
  export GOROOT=`go env GOROOT`
  export GOPATH=$HOME/.go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

#
# nodebrew
#

if [ -x "`which nodebrew`" ]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

# os specific configs
case ${OSTYPE} in
    linux*)
        source ~/.zprofile.linux
        ;;
esac


