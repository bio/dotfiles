## Installation

    mkdir -p ~/tmp/vim
    cd ~
    git clone https://bio@github.com/bio/dotfiles.git
    cd dotfiles
    git submodule init
    git submodule update

    ln -s ~/dotfiles/vimrc ~/.vimrc
    ln -s ~/dotfiles/gvimrc ~/.gvimrc
    ln -s ~/dotfiles/vim ~/.vim

### Adding Plugin Bundles

    cd ~/dotfiles
    git submodule add https://github.com/bio/vim-mac-classic-theme.git vim/bundle/vim-mac-classic-theme
    git add .
    git ci -m "add Mac Classic theme"

