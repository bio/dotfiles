## Installation

    mkdir -p ~/tmp/vim
    cd ~
    git clone https://github.com/bio/dotfiles.git
    cd dotfiles
    git submodule update --recursive --init

    ln -s ~/dotfiles/zshrc ~/.zshrc
    ln -s ~/dotfiles/vimrc ~/.vimrc
    ln -s ~/dotfiles/gvimrc ~/.gvimrc
    ln -s ~/dotfiles/vim ~/.vim
    ln -s ~/dotfiles/gitconfig ~/.gitconfig
    ln -s ~/dotfiles/ackrc ~/.ackrc
    ln -s ~/dotfiles/psqlrc ~/.psqlrc
    touch ~/.psqlrc_local

### Configure Plugins

#### Command-T

    cd ~/dotfiles/vim/bundles/repos/github.com/wincent/command-t/ruby/command-t/ext/command-t
    ruby extconf.rb
    make

## Updating

    cd ~/dotfiles
    git submodule foreach git pull
