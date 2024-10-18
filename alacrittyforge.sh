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

if nslookup google.com &> /dev/null; then
    # If there is a connection, display "AlacrittyForge" in ASCII
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
else
    echo "No internet connection detected. Please check your network adapter and rerun the script."
    exit 1  # Exit the script if no connection
fi
# Function to install Alacritty without updating
install_alacritty() {
    echo -e "\nInstalling Alacritty without updating system packages..."

    # Installing dependencies
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev cargo \
    libxcb-xfixes0-dev libxkbcommon-dev python3 libglib2.0-dev \
    libgdk-pixbuf2.0-dev libxi-dev libxrender-dev libxrandr-dev libxinerama-dev

    # Installing Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    sudo apt install -y build-essential

    # Cloning the repository and navigating to the directory
    git clone https://github.com/alacritty/alacritty.git 2>/dev/null
    cd alacritty || { echo "Could not change to the Alacritty directory."; exit 1; }

    # Installing via cargo
    cargo build --release

    # Creating a GUI icon
    sudo cp target/release/alacritty /usr/local/bin 
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
}


# Function to update and then install Alacritty
update_and_install_alacritty() {
    echo "Updating system packages and installing Alacritty..."
    sudo apt update && sudo apt upgrade -y
    install_alacritty
}


# Function to change Alacritty theme
change_alacritty_theme() {
    echo -e "\nAlacritty Theme Selector:"
    # Using the default Linux config directory to store themes
    mkdir -p ~/.config/alacritty/themes 2>/dev/null
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes 2>/dev/null

    echo -e "\nAvailable themes and appearance in the attached repository: https://github.com/alacritty/alacritty-theme"

    # Prompt the user to enter the theme name
    read -p "Enter the Alacritty theme name (e.g., aura, blood_moon, gruvbox_dark): " theme

    # Verify that the theme directory and file exist
    theme_file="$HOME/.config/alacritty/themes/themes/${theme}.toml"
    if [[ -f "$theme_file" ]]; then
        # Alacritty configuration file
        config_file="$HOME/.config/alacritty/alacritty.toml"

        # Create the correct import line format
        new_import_line="import = [\"$theme_file\"]"

        # Check if the import section already exists
        if grep -q "^import =" "$config_file"; then
            # Replace the existing import line
            sed -i "s|^import = .*|$new_import_line|" "$config_file"
            echo "Theme '$theme' successfully replaced in the configuration."
        else
            # If not, add the new import line
            echo -e "$new_import_line\n" >> "$config_file"
            echo "Theme '$theme' successfully added to the configuration."
        fi

        # Migrate the file to apply the theme change instantly
        echo "Launching Alacritty with theme '$theme'..."
        alacritty migrate
    else
        echo "The theme '$theme' does not exist. Please make sure the ${theme}.toml file is located in ~/.config/alacritty/themes/themes/"
        exit 1
    fi
}


# Menu selection
while true; do
    echo "Select an option:"
    echo "1) Install Alacritty without checking for updates."
    echo "2) Update system packages and install Alacritty."
    echo "3) Change Alacritty theme."
    echo "4) Exit"

    read -p "Enter your option (1-4): " option

    case $option in
        1)
            install_alacritty
            ;;
        2)
            update_and_install_alacritty
            ;;
        3)
            change_alacritty_theme
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac

    echo -e "\n"
done
