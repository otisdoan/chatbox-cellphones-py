#!/bin/bash
set -e

# Upgrade pip
python -m pip install --upgrade pip

# Set environment variables to prefer binary packages
export PIP_PREFER_BINARY=1

# Install dependencies with explicit flags
pip install --prefer-binary -r requirements.txt || {
    echo "Prefer-binary install failed, trying a normal install..."
    pip install -r requirements.txt
}