## Installation

    cd ~
    git clone https://github.com/bio/dotfiles.git

    ln -s ~/dotfiles/.config ~/.config
    ln -s ~/dotfiles/.config/vim/gvimrc ~/.gvimrc
    ln -s ~/dotfiles/.config/vim/vimrc ~/.vimrc
    ln -s ~/dotfiles/ackrc ~/.ackrc
    ln -s ~/dotfiles/psqlrc ~/.psqlrc
    ln -s ~/dotfiles/zshrc ~/.zshrc

    touch ~/.psqlrc_local
    mkdir -p ~/tmp/vim

### Install plugin manager

#### Vim

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
