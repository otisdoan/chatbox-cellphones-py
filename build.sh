#!/bin/bash
set -e

# Upgrade pip
python -m pip install --upgrade pip

# Set environment variables to prefer binary packages
export PIP_PREFER_BINARY=1
export PIP_ONLY_BINARY=":all:"

# Install dependencies with explicit flags
pip install --prefer-binary --only-binary=:all: -r requirements.txt || {
    echo "Binary installation failed, trying without strict binary requirement..."
    pip install --prefer-binary -r requirements.txt
}