## Installation

    mkdir -p ~/tmp/vim
    cd ~
    git clone https://github.com/bio/dotfiles.git
    cd dotfiles
    git submodule init
    git submodule update

    ln -s ~/dotfiles/zshrc ~/.zshrc
    ln -s ~/dotfiles/vimrc ~/.vimrc
    ln -s ~/dotfiles/gvimrc ~/.gvimrc
    ln -s ~/dotfiles/vim ~/.vim
    ln -s ~/dotfiles/gitconfig ~/.gitconfig
    ln -s ~/dotfiles/ackrc ~/.ackrc

### Adding Plugin Bundles

    cd ~/dotfiles
    git submodule add https://github.com/bio/vim-mac-classic-theme.git vim/bundle/vim-mac-classic-theme
    git add .
    git ci -m "add Mac Classic theme"

#### Command-T

    cd ~/dotfiles/vim/bundle/command-t/ruby/command-t
    ruby extconf.rb
    make

## Updating

    cd ~/dotfiles
    git submodule foreach git pull

