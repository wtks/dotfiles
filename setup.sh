#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

dir=$(cd $(dirname $0);pwd)

# save dotfiles' directory path
echo $dir > "$HOME/.dotpath"

ln -svf "$dir/.zprofile" $HOME
ln -svf "$dir/.zshenv" $HOME
ln -svf "$dir/.zshrc" $HOME
ln -svf "$dir/.zlogout" $HOME
ln -svf "$dir/.zlogin" $HOME

ln -svf "$dir/.tmux.conf" $HOME

ln -svf "$dir/.pylintrc" $HOME

ln -svf "$dir/.tigrc" $HOME

if [ ! -e "$HOME/.config/" ]; then
    mkdir "$HOME/.config"
fi

ln -svf "$dir/.config/nvim" "$HOME/.config"

# zplug install
if [ ! -e "$HOME/.zplug/" ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# Linux
if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    ln -svf "$dir/.config/i3" "$HOME/.config/"
    ln -svf "$dir/.config/rofi" "$HOME/.config/"
    ln -svf "$dir/.config/polybar" "$HOME/.config/"

    if [ ! -e "$HOME/.config/mpd/" ]; then
        mkdir "$HOME/.config/mpd/"
    fi
    ln -svf "$dir/.config/mpd/mpd.conf" "$HOME/.config/mpd/"

    if [ ! -e "$HOME/.ncmpcpp/" ]; then
        mkdir "$HOME/.ncmpcpp"
    fi
    ln -svf "$dir/.ncmpcpp/config" "$HOME/.ncmpcpp/"

    ln -svf "$dir/.conkyrc" $HOME
    ln -svf "$dir/.Xresources" $HOME
    ln -svf "$dir/.Xmodmap" $HOME
    ln -svf "$dir/.zprofile.linux" $HOME
fi
