#!/bin/bash
#:Title: alacrittyforge.sh
#:Version: 1.0
#:Author: Pablo Fernández López
#:Date: 10/17/2024
#:Description: Script to manage the installation and configuration of Alacritty, 
# a terminal emulator. Allows installing Alacritty, updating packages, and changing
# the terminal theme via an interactive menu.
#:Usage:
#:        - Option 1): Installs Alacritty without updating system packages.
#:        - Option 2): Updates system packages and then installs Alacritty.
#:        - Option 3): Allows changing the Alacritty theme by putting the theme name (available from the alacritty/themes repo) instantly.
#:Dependencies:
#:        - "CMake", "Pkg-config", "libfreetype6-dev", "libfontconfig1-dev", "Cargo", "libxcb-xfixes0-dev"
#:        - "libxkbcommon-dev", "Python3", "libglib2.0-dev", "libgdk-pixbuf2.0-dev", "libxi-dev", "libxrender-dev", "libxrandr-dev", "libxinerama-dev"
#:Credits: @chrisduerr and @kchibisov, creators of Alacritty.


    echo -e "\n-----------------------------------------------------------------------------------------------------------------"
    echo -e "-----------------------------------------------------------------------------------------------------------------\n"
    echo "  █████╗ ██╗      █████╗  ██████╗██████╗ ██╗████████╗████████╗██╗   ██╗███████╗ ██████╗ ██████╗  ██████╗ ███████╗"
    echo " ██╔══██╗██║     ██╔══██╗██╔════╝██╔══██╗██║╚══██╔══╝╚══██╔══╝╚██╗ ██╔╝██╔════╝██╔═══██╗██╔══██╗██╔════╝ ██╔════╝"
    echo " ███████║██║     ███████║██║     ██████╔╝██║   ██║      ██║    ╚████╔╝ █████╗  ██║   ██║██████╔╝██║  ███╗█████╗"
    echo " ██╔══██║██║     ██╔══██║██║     ██╔══██╗██║   ██║      ██║     ╚██╔╝  ██╔══╝  ██║   ██║██╔══██╗██║   ██║██╔══╝"
    echo " ██║  ██║███████╗██║  ██║╚██████╗██║  ██║██║   ██║      ██║      ██║   ██║     ╚██████╔╝██║  ██║╚██████╔╝███████╗"
    echo " ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝      ╚═╝   ╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
    echo -e "\n-----------------------------------------------------------------------------------------------------------------"
    echo -e "-----------------------------------------------------------------------------------------------------------------\n"

install_alacritty() {
    read -p "Do you also want to install oh-my-bash?(y/n)" option_ohmybash
    echo -e "\nInstalling Alacritty without updating system packages..."

    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev cargo \
    libxcb-xfixes0-dev libxkbcommon-dev python3 libglib2.0-dev \
    libgdk-pixbuf2.0-dev libxi-dev libxrender-dev libxrandr-dev libxinerama-dev
    
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    sudo apt install -y build-essential

    git clone https://github.com/alacritty/alacritty.git 2>/dev/null
    cd alacritty || { echo "Could not change to the Alacritty directory."; exit 1; }

    cargo build --release
    
    sudo cp target/release/alacritty /usr/local/bin 
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    if [["$option_ohmybash" == "y"]]; then
        install_ohmybash
    else
        echo -e "oh_my_bash install option not selected."
    fi

}
install_ohmybash(){
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    read -p "Do you also want to apply a theme from oh-my-bash?(y/n)" option_ohmybash_theme
    if [["$option_ohmybash" == "y"]]; then
        read -p "Name of the theme (Just type the name of the theme from this repo https://github.com/ohmybash/oh-my-bash/wiki/Themes): " theme_selected

        if grep -q "OSH_THEME=" ~/.bashrc; then
            sed -i.bak "s/^OSH_THEME=.*/OSH_THEME=\"$theme_selected\"/" ~/.bashrc
        else
            echo "OSH_THEME=\"$theme_selected\"" | tee -a ~/.bashrc > /dev/null
        fi
    
        echo -e "Theme '$theme_selected' has been applied to your Oh My Bash configuration."
    else
        echo -e "Installation finished without selecting a theme."
    fi

}

change_theme_ohmybash(){
    read -p "Name of the theme (Just type the name of the theme from this repo https://github.com/ohmybash/oh-my-bash/wiki/Themes): " theme_selected

    if grep -q "OSH_THEME=" ~/.bashrc; then
        sed -i.bak "s/^OSH_THEME=.*/OSH_THEME=\"$theme_selected\"/" ~/.bashrc
    else
        echo "OSH_THEME=\"$theme_selected\"" | tee -a ~/.bashrc > /dev/null
    fi
    echo -e "Theme '$theme_selected' has been applied to your Oh My Bash configuration."
}

update_and_install_alacritty() {
    echo "Updating system packages and installing Alacritty..."
    sudo apt update && sudo apt upgrade -y
    install_alacritty
}

change_theme_alacritty() {
    echo -e "\nAlacritty Theme Selector:"
    mkdir -p ~/.config/alacritty/themes 2>/dev/null
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes 2>/dev/null

    echo -e "\nAvailable themes and appearance in the attached repository: https://github.com/alacritty/alacritty-theme"

    read -p "Enter the Alacritty theme name (e.g., aura, blood_moon, gruvbox_dark): " theme

    theme_file="$HOME/.config/alacritty/themes/themes/${theme}.toml"
    if [[ -f "$theme_file" ]]; then
        config_file="$HOME/.config/alacritty/alacritty.toml"

        new_import_line="import = [\"$theme_file\"]"

        if grep -q "^import =" "$config_file"; then
            sed -i "s|^import = .*|$new_import_line|" "$config_file"
            echo "Theme '$theme' successfully replaced in the configuration."
        else
            echo -e "$new_import_line\n" >> "$config_file"
            echo "Theme '$theme' successfully added to the configuration."
        fi
        
        echo "Launching Alacritty with theme '$theme'..."
        alacritty migrate
    else
        echo "The theme '$theme' does not exist. Please make sure the ${theme}.toml file is located in ~/.config/alacritty/themes/themes/"
        exit 1
    fi
}


while true; do
    echo "Select an option:"
    echo "1) Install Alacritty without checking for updates."
    echo "2) Update system packages and install Alacritty."
    echo "3) Change Alacritty theme."
    echo "4) Change oh-my-bash theme."
    echo "5) Exit"

    read -p "Enter your option (1-4): " option

    case $option in
        1)
            install_alacritty
            ;;
        2)
            update_and_install_alacritty
            ;;
        3)
            change_theme_alacritty
            ;;
        4)
            change_theme_ohmybash
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac

    echo -e "\n"
done
