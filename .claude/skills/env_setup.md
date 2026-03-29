---
name: env_setup
description: Complete Mac development environment setup for Claude Code
---

# Mac Development Environment Setup for Claude Code

This skill guides you through setting up a brand new Mac for optimal development with Claude Code.

## 🚀 Quick Setup (Run Outside Claude Code)

**Automated Setup Script**: Run this bash script in your terminal (outside Claude Code) to install all tools.

```bash
# Run the setup script
bash ~/.claude/skills/setup_env.sh
```

The script will:
- ✓ Create necessary directories
- ✓ Install/update Homebrew
- ✓ Install essential development tools (git, gh, node, yarn, pnpm, python, pipx)
- ✓ Install development utilities (tree, ripgrep, fd, fzf, bat, jq, yq, wget, httpie, tmux)
- ✓ Configure shell enhancements (zsh-autosuggestions, zsh-syntax-highlighting)
- ✓ Verify Git and GitHub CLI configuration

**For Claude Code**: When the user requests env_setup, verify installations using the verification commands below instead of running installations.

---

## ✅ Verification (For Claude Code)

When the user asks to verify the environment setup, run these commands to check installations:

```bash
# Check Homebrew
which brew

# Check essential tools
which git && which gh && which node && which yarn && which pnpm && which python3 && which pipx

# Check development utilities
which tree && which rg && which fd && which fzf && which bat && which jq && which yq && which wget && which http && which tmux

# Check Git configuration
git config --global user.name
git config --global user.email

# Check GitHub CLI authentication
gh auth status
```

**Report Format**: Summarize what's installed and what's missing. If tools are missing, remind the user to run `bash ~/.claude/skills/setup_env.sh` outside Claude Code.

---

## 📋 Prerequisites
- macOS (latest stable version recommended)
- Admin access to install software

---

## 📖 Manual Setup Instructions

If you prefer manual setup or need to understand what the script does, follow these steps:

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