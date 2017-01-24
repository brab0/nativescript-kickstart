#!/bin/sh
sudo true

[ "$(which npm)" != "" ] && has_npm=true || has_npm=false
[ "$(which node)" != "" ] && has_node=true || has_node=false
[ "$(which git)" != "" ] && has_git=true || has_git=false
[ "$(which tns)" != "" ] && has_tns=true || has_tns=false
[ "$(which brew)" != "" ] && has_brew=true || has_brew=false
[ -d ".git" ] && has_project=true || has_project=false

os=null
repo="nativescript-kickstart"

if [ "$OSTYPE" == "linux-gnu" ]; then
    os="linux"
else
    os="ios"
fi

#if [ $has_npm == false ]; then
    read -p "This project requires NPM to work properly. Shall we install it for you [y/n]? " answer < /dev/tty
    if [ "$answer" == [Yy]* ]; then
        echo "Installing NPM..."
        curl -L https://www.npmjs.com/install.sh | sh
        echo "...NPM version $(npm --version) installed!"
    else
        echo "No, I will do it for my self!"
    fi
#fi

#if [ $has_node == false ]; then
    read -p "This project requires NodeJs to work properly. Shall we install it for you [y/n]? " answer < /dev/tty
    if [ "$answer" == [Yy]* ]; then
        echo "Installing NodeJs..."
        npm cache clean -f
        npm install -g n
        n stable
        clear
        echo "...NodeJs version $(node --version) installed!"
    else
        echo "You're on your own!"
    fi
#fi

#if [ $has_tns == false ]; then
    read -p "This project requires NativeScript to work properly. Do you wanna install it globally [y/n]? " answer < /dev/tty
    if [ "$answer" == [Yy]* ]; then
        echo "Installing NativeScript..."
        npm install -g nativescript
        clear
        echo "...TNS version $(tns --version) installed!"
    else
        echo "hum..."
    fi
#fi

#if [ $has_git == false ]; then
    read -p "Do you wanna install Git [y/n]? " answer < /dev/tty
    if [ "$answer" == [Yy]* ]; then
        if [ "$os" == "linux" ]; then
            sudo apt-get update
            sudo apt-get install git-all
        elif [ "$os" == "ios" ]; then
            if [ $has_brew == false ]; then
                read -p "You need to install Homebrew. Do you want we install it for you \(y/n\)? " answer < /dev/tty
                if [ "$answer" == [Yy]* ]; then
                    echo "Installing Homebrew..."
                    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
                    echo "Installing GIT..."
                    brew install git
                fi
            else
                echo "All right!"              
            fi
        fi
        clear
        echo "...$(git --version) installed!"
    else
        echo "Whaaat???"
    fi
#fi

#if [ $has_project == false ]; then
    read -p "Do you wanna clone this NativeScript Kickstart project from Github repository \(y/n\)? " answer < /dev/tty
    if [ "$answer" == [Yy]* ]; then
        read -p "Do you wanna change the directorys name \($repo\)? \(y/n\)? " answer < /dev/tty
        if [ "$answer" == [Yy]* ]; then
            read -p "Type the new name: " repo < /dev/tty
        else
            echo "No, the current name is fine!"
        fi
    
        git clone "https://github.com/brab0/nativescript-kickstart $repo"
        cd $repo
        clear
        echo "...repository cloned!"
    else  
        echo "=("
    fi
#fi

echo "Enjoy!"
