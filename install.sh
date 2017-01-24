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

if [ $has_npm == false ]; then
    read -p "This project requires NPM. Do you wanna install it [y/n]? " answer < /dev/tty
    if [[ "$answer" == [Yy]* ]]; then
        echo "Installing NPM..."
        sudo curl -L https://www.npmjs.com/install.sh | sh
        echo "...NPM version $(npm --version) installed!"
    fi
fi

if [ $has_node == false ]; then
    read -p "This project requires NodeJs. Do you wanna install it [y/n]? " answer < /dev/tty
    if [[ "$answer" == [Yy]* ]]; then
        echo "Installing NodeJs..."
        sudo npm cache clean -f
        sudo npm install -g n
        sudo n stable
        clear
        echo "...NodeJs version $(node --version) installed!"
    fi
fi

if [ $has_tns == false ]; then
    read -p "This project requires NativeScript(tns). Do you wanna install it globally [y/n]? " answer < /dev/tty
    if [[ "$answer" == [Yy]* ]]; then
        echo "Installing NativeScript..."
        sudo npm install -g nativescript
        clear
        echo "...TNS version $(tns --version) installed!"
    fi
fi

if [ $has_git == false ]; then
    read -p "Do you wanna install Git [y/n]? " answer < /dev/tty
    if [[ "$answer" == [Yy]* ]]; then
        if [ "$os" == "linux" ]; then
            sudo apt-get update
            sudo apt-get install git-all
        elif [ "$os" == "ios" ]; then
            if [ $has_brew == false ]; then
                read -p "You need to install Homebrew. Do you want we install it for you [y/n]? " answer < /dev/tty
                if [[ "$answer" == [Yy]* ]]; then
                    echo "Installing Homebrew..."
                    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
                    echo "Installing GIT..."
                    sudo brew install git
                fi
            fi
        fi
        clear
        echo "...$(git --version) installed!"
    fi
fi

if [ $has_project == false ]; then
    if [ $has_git == true ]; then
        read -p "Do you wanna clone this NativeScript Kickstart project from Github repository [y/n]? " answer < /dev/tty
        if [[ "$answer" == [Yy]* ]]; then
            read -p "Do you wanna change the directory's name ($repo)? [y/n]? " answer < /dev/tty
            if [[ "$answer" == [Yy]* ]]; then
                read -p "Type the new name: " repo < /dev/tty
            fi

            sudo git clone https://github.com/brab0/nativescript-kickstart $repo            
            cd $repo
            has_project=true
            clear
            echo "...repository cloned!"
        fi
    else
        echo "...we could not clone the projet because you don't have Git installed...told you!"
    fi
fi

if [ $has_project == true ]; then
    read -p "Do you wanna link this project to another remote Git repository [y/n]? " answer < /dev/tty
    if [[ "$answer" == [Yy]* ]]; then
        read -p "Type the repositorys url: " input_variable < /dev/tty
        sudo git remote rename origin upstream
        sudo git remote add origin $input_variable
        sudo git push origin master
        clear
        echo "...your project was successfully pushed to another repository!"
    fi
fi

if [ $has_project == true ]; then
    if [ $has_npm == true ]; then
        read -p "Do you wanna install the project's dependencies now [y/n]? " answer < /dev/tty
        if [[ "$answer" == [Yy]* ]]; then
            sudo npm install
            clear
            echo "...all dependencies installed!"
        fi
    else
        echo "We cannot install the project's dependencies 'cause you don't have npm installed...I told you!"
    fi
fi

if [ $has_project == true ]; then
    if [ $has_tns == true ]; then
        read -p "Do you wanna add Android platform to the project [y/n]? " answer < /dev/tty
        if [[ "$answer" == [Yy]* ]]; then
            tns platform add android
            clear
            echo "...Android platform added!"
        fi
        
        if [ "$os" == "ios" ]; then
            read -p "Do you wanna add iOS platform to the project [y/n]? " answer < /dev/tty
            if [[ "$answer" == [Yy]* ]]; then
                tns platform add ios
                clear
                echo "iOS platform added!"
            fi 
        fi
    else
        echo "We cannot not install add mobile platforms 'cause you don't have tns installed...told you!"
    fi       
fi

echo "Enjoy!"
