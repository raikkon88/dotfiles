#!/bin/bash

function check_sudo_access() {
    echo "Verifying sudo access..."
    
    # Run a harmless sudo command to prompt for password if needed.
    # The `-v` flag validates the timestamp without running a command.
    if sudo -v &> /dev/null; then
        echo "Sudo access verified. Password cached for a few minutes."
    else
        echo "Sudo access could not be verified. Please check your privileges."
        exit 1
    fi
}

function update() {
    sudo apt update
    sudo apt upgrade
}

function setup_ohmyzsh()  {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function update_homebrew() {
    # Check if Homebrew is installed
    if which brew > /dev/null 2>&1; then
        echo "Checking for Homebrew updates..."
        # First, update the package definitions to get the latest info
        brew update
        
        # Check if any packages are outdated
        if [ "$(brew outdated | wc -l)" -gt 0 ]; then
            echo "Updates are available."
            echo "Do you want to apply them? (y/n)"
            read -r response
            if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
                echo "Upgrading Homebrew packages..."
                brew upgrade
                echo "Homebrew upgrade complete."
            else
                echo "Skipping Homebrew upgrade."
            fi
        else
            echo "Homebrew and all packages are up to date."
        fi
    else
        echo "Homebrew is not installed. Skipping update check."
    fi
}

function brew_setup() {
    # Check if Homebrew is installed
    if ! which "brew" > /dev/null 2>&1; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        /home/linuxbrew/.linuxbrew/bin/brew install zsh

        echo >> ~/.zshrc
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        OS=$(uname -s)

        # Check if the OS is macOS or Linux
        if [ "$OS" = "Darwin" ]; then
            echo "Detected macOS. Checking for Xcode Command Line Tools..."
            # On macOS, install Xcode Command Line Tools
            if ! xcode-select -p > /dev/null 2>&1; then
                echo "Xcode Command Line Tools not found. Installing..."
                xcode-select --install
                echo "Installation of Xcode Command Line Tools is complete."
            else
                echo "Xcode Command Line Tools are already installed."
            fi
        elif [ "$OS" = "Linux" ]; then
            # On Linux, assume it's a Debian-based system (like Ubuntu)
            # and install build-essential
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                if [ "$ID" = "ubuntu" ] || [ "$ID" = "debian" ]; then
                    echo "Detected Ubuntu/Debian. Installing build-essential..."
                    sudo apt-get update
                    sudo apt-get install build-essential
                else
                    echo "Detected a Linux distribution that is not Ubuntu or Debian. Skipping build-essential installation."
                fi
            else
                echo "Could not determine Linux distribution. Skipping build-essential installation."
            fi
        else
            echo "Unsupported operating system: $OS. Skipping build-essential installation."
        fi

        brew install gcc

        setup_ohmyzsh
    else
        echo "Homebrew is already installed."
        update_homebrew
    fi
}

function install_packages() {
    # Installing packages
    for item in "$@"; do
        if command -v "$item" > /dev/null 2>&1; then
            echo "$item is already installed, checking for updates..."
            brew install "$item"
        else
            echo "$item is not installed. Installing..."
            brew install "$item"
        fi
    done
}

function install_graphic_packges() {
    
    OS=$(uname -s)
    # Installing cask packages
    for item in "$@"; do
        if command -v "$item" > /dev/null 2>&1; then
            echo "$item is already installed, checking for updates..."
            if [ "$OS" = "Darwin" ]; then
                brew install --cask "$item"
            else
                sudo snap install "$item"
            fi
        else
            echo "$item is not installed. Installing..."
            if [ "$OS" = "Darwin" ]; then
                brew install --cask "$item"
            else
                sudo snap install "$item"
            fi
        fi
    done 

}

function install_packages_from_source() {
    sources=$1
    for source in "$@"; do
        tmp_dir=$(mktemp -d)
        wget -O "$tmp_dir/app.deb" $source
        sudo apt install "$tmp_dir/app.deb"
    done
}

function install_spotify_for_ubuntu() {
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client
}