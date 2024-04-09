#!/bin/bash


setup_python_environment() {
    echo "Updating package lists..."
    sudo apt-get update -qq >/dev/null 2>&1

    if [ -d "$HOME/miniconda" ]; then
        echo "Miniconda already installed at $HOME/miniconda. Proceed to create a conda environment."
    else
        echo "Installing Miniconda..."
        wget --quiet --show-progress --progress=bar:force:noscroll https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
        bash ~/miniconda.sh -b -p $HOME/miniconda
        export PATH="$HOME/miniconda/bin:$PATH"
        rm ~/miniconda.sh
    fi

    # Ensure Conda is correctly initialized
    source ~/miniconda/bin/activate
    ~/miniconda/bin/conda init bash >/dev/null 2>&1

    # Source .bashrc to update the path for conda, if it exists
    if [ -f "$HOME/.bashrc" ]; then
        echo "Sourcing .bashrc to update the path for conda"
        source "$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        # Fallback for systems that use .bash_profile instead of .bashrc
        echo "Sourcing .bash_profile to update the path for conda"
        source "$HOME/.bash_profile"
    else
        echo "Could not find a .bashrc or .bash_profile file to source."
    fi

    # Check if the Conda environment already exists
    if conda info --envs | grep 'llm-venv' > /dev/null; then
        echo "Conda environment 'llm-venv' already exists. Skipping creation."
    else
        echo "Creating a virtual environment with Miniconda..."
        # Suppressing the output completely, consider logging at least errors
        conda create -n llm-venv python=3.11 -y --quiet >/dev/null 2>&1
        echo "Conda virtual environment 'llm-venv' created."
    fi

    conda activate llm-venv
    echo "Conda virtual environment 'llm-venv' activated."
}

install_dependencies() {
    echo "Installing Python dependencies..."
    local dependencies=("vllm" "python-dotenv" "toml" "openai" "triton==2.1.0" "wheel" "packaging")

    for dep in "${dependencies[@]}"; do
        if ! install_with_spinner "$dep"; then
            echo "Failed to install $dep."
            exit 1
        fi
    done

    echo "All dependencies installed successfully."
}

main() {
    setup_python_environment
    install_dependencies
}

main