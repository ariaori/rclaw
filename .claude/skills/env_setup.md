---
name: env_setup
description: Complete Mac development environment setup for Claude Code
---

# Mac Development Environment Setup for Claude Code

This skill guides you through setting up a brand new Mac for optimal development with Claude Code.

## 📋 Prerequisites
- macOS (latest stable version recommended)
- Admin access to install software

## 🚀 Step-by-Step Setup

### Step 1: Create Claude Code Directory Structure
```bash
# Create personal skills folder (FIRST PRIORITY)
mkdir -p ~/.claude/skills
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/templates

# Create a working directory for projects
mkdir -p ~/Development
```

### Step 2: Install Homebrew (Package Manager)
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (for Apple Silicon Macs)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# For Intel Macs
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

### Step 3: Install Essential Development Tools
```bash
# Version control
brew install git
brew install gh  # GitHub CLI

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Authenticate GitHub CLI
gh auth login

# Node.js and package managers
brew install node
brew install yarn
brew install pnpm

# Python (macOS comes with Python, but brew version is better)
brew install python@3.11
brew install pipx
```

### Step 4: Install Development Utilities
```bash
# File management and search
brew install tree
brew install ripgrep  # Fast grep
brew install fd       # Fast find
brew install fzf      # Fuzzy finder
brew install bat      # Better cat with syntax highlighting

# JSON/YAML tools
brew install jq       # JSON processor
brew install yq       # YAML processor

# HTTP tools
brew install curl
brew install wget
brew install httpie

# Terminal improvements
brew install --cask iterm2  # Better terminal
brew install tmux           # Terminal multiplexer
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

# Add to ~/.zshrc
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
```