#!/bin/bash
source os_installation.zsh

check_sudo_access

brew_setup

packages=(
    "git" 
    "chezmoi" 
    "htop" 
    "bat" 
    "eza" 
    "nvm" 
    "docker" 
    "wget" 
    "curl" 
    "awscli"
)

mac_graphic_packages=(
    "visual-studio-code" 
    "spotify" 
    "ghostty" 
    "insomnia" 
    "mongodb-compass" 
    "1password" 
    "arc"
)

download_url_packages=(
    "https://go.microsoft.com/fwlink/?LinkID=760868"
    "https://downloads.mongodb.com/compass/mongodb-compass_1.46.9_amd64.deb"
    "https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb"
    "https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.1.3-0-ppa2/ghostty_1.1.3-0.ppa2_amd64_24.04.deb"
    "https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website"
)



install_packages "${packages[@]}"


OS=$(uname -s)
if [ "$OS" = "Linux" ]; then
    install_packages_from_source "${download_url_packages[@]}"
    install_spotify_for_ubuntu 
elif [ "$OS" = "Darwin" ]; then
    install_graphic_packges "${mac_graphic_packages[@]}"
fi


