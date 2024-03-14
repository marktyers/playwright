#!/bin/bash

# INSTALLATION SCRIPT FOR THE API/SPA TEMPLATE

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo
echo "======= CHECKING WE ARE ON A CODIO BOX ======="
if [ -v CODIO_HOSTNAME ]
then
	echo "Codio box detected"
	echo "continuing setup"
else
	echo "no Codio box detected"
	echo "exiting setup"
	exit 1
fi

type=${CODIO_TYPE:-assignment}

if [ $type = "lab" ];
then
	echo "YOU ARE TRYING TO RUN THIS IN A CODIO **LAB**"
	echo "script should only be run in your assignment box"
	exit 1
fi

echo
echo "============ INSTALLING PACKAGES ============"

# sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y psmisc lsof tree build-essential gcc g++ make jq curl unzip inotify-tools dnsutils lcov tilde bash-completion
sudo apt install -y  git

# # install zsh
sudo apt install -y zsh fonts-font-awesome

# install NodeJS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# install Oh My Zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

if grep clear ~/.profile
then
  echo "clear command found"
else
  echo "clear command needs adding"
	echo "PS1='$ '" >> ~/.profile
  echo "clear" >> ~/.profile
	echo "cd workspace" >> ~/.zshrc
	echo "clear" >> ~/.zshrc
fi


echo
echo "================= CONFIGURING ${green}GIT${reset} =================="
git init
git config core.hooksPath .githooks
git config --global merge.commit no
git config --global merge.ff no
git config --global --unset user.email
git config --global --unset user.name
git config --global core.editor tilde

# git config --global user.name "Your Name"
# git config --global user.email "youremail@yourdomain.com"

source ~/.profile

# set up the react app
npm install create-react-app@5.0.1
npx create-react-app website

rm README.md
mv website/* .
mv website/.gitignore .
rm -rf website

npm init playwright@latest
