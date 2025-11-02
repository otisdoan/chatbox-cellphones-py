#!/bin/bash
set -e

# Setup Cargo directories
export CARGO_HOME=/tmp/cargo
export CARGO_TARGET_DIR=/tmp/cargo-target
mkdir -p $CARGO_HOME $CARGO_TARGET_DIR

# Upgrade pip
python -m pip install --upgrade pip

# Install dependencies
pip install --no-cache-dir -r requirements.txt