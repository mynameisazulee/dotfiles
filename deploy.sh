#!/bin/bash

# Install modules
# should be "[system_config_file]:[my_config_file]"
MODULES=(".zshrc:zsh/zshrc.conf" ".vimrc:vim/vimrc.conf" ".tmux.conf:tmux/tmux.conf")

function update_system_file {
    echo "source $1" > "$2"
}

function deploy_module {
    folder=$(eval echo "~$USER")
    system_file="$folder/$1"
    my_file="$folder/dotfiles/$2"

    if [ ! -e $system_file ]; then
        echo "$system_file doesn't exist. creating one."
        update_system_file $my_file $system_file
    else
            while true; do
            read -p "Do you want to backup your $system_file before udpating it? [y/n/c]" yn
            case $yn in
            [Yy]* ) mv "$system_file" "$system_file.backup"; update_system_file $my_file $system_file; break;;
            [Nn]* ) update_system_file $my_file $system_file ; break;;
            [Cc]* ) exit;;
            * ) echo "please select y or n"; exit;;
            esac
        done
    fi
}

for module in "${MODULES[@]}" ; do
    KEY=${module%%:*}
    VALUE=${module#*:}
    deploy_module $KEY $VALUE
done

# Install Vim Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Vim Plugins
cd ~/.vim/bundle
git clone https://github.com/altercation/vim-colors-solarized
git clone https://github.com/scrooloose/nerdtree
git clone https://github.com/terryma/vim-multiple-cursors
# git clone https://github.com/ervandew/supertab
git clone https://github.com/scrooloose/syntastic

# Zsh Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
