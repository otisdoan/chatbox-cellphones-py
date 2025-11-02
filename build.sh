#!/bin/bash
set -e

# Upgrade pip
python -m pip install --upgrade pip

# Set environment variables to prefer binary packages
export PIP_PREFER_BINARY=1

# Configure Cargo/Rust writable directories to avoid read-only filesystem errors
export CARGO_HOME=/tmp/cargo
export RUSTUP_HOME=/tmp/rustup
mkdir -p "$CARGO_HOME" "$RUSTUP_HOME"

# Install dependencies with explicit flags (prefer wheels but allow source builds)
pip install --prefer-binary -r requirements.txt || {
    echo "Prefer-binary install failed, trying a normal install..."
    pip install -r requirements.txt
}