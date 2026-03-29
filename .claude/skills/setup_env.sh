#!/bin/bash

# Mac Development Environment Setup Script
# Run this script outside Claude Code to install development tools

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}Mac Development Environment Setup${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# Step 1: Create directory structure
echo -e "${BLUE}=== Creating Directory Structure ===${NC}"
mkdir -p ~/.claude/skills
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/templates
mkdir -p ~/Development
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

# Step 2: Check Homebrew
echo -e "${BLUE}=== Checking Homebrew ===${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to PATH
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
    echo -e "${BLUE}Updating Homebrew...${NC}"
    brew update
fi
echo ""

# Step 3: Install essential development tools
echo -e "${BLUE}=== Installing Essential Development Tools ===${NC}"
brew install git gh node yarn pnpm python@3.11 pipx
echo -e "${GREEN}✓ Essential tools installed${NC}"
echo ""

# Step 4: Install development utilities
echo -e "${BLUE}=== Installing Development Utilities ===${NC}"
brew install tree ripgrep fd fzf bat jq yq curl wget httpie tmux
echo -e "${GREEN}✓ Development utilities installed${NC}"
echo ""

# Step 5: Install shell enhancements
echo -e "${BLUE}=== Installing Shell Enhancements ===${NC}"
brew install zsh-autosuggestions zsh-syntax-highlighting

# Add to .zshrc if it exists
if [ -f ~/.zshrc ]; then
    if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Claude Code setup enhancements" >> ~/.zshrc
        echo "source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
        echo "source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
        echo -e "${GREEN}✓ Shell enhancements added to ~/.zshrc${NC}"
    else
        echo -e "${GREEN}✓ Shell enhancements already configured${NC}"
    fi
else
    echo -e "${YELLOW}⚠ ~/.zshrc not found. Shell enhancements skipped.${NC}"
fi
echo ""

# Step 6: Verify Git config
echo -e "${BLUE}=== Checking Git Configuration ===${NC}"
if [ -z "$(git config --global user.name)" ]; then
    echo -e "${YELLOW}⚠ Git user.name not set${NC}"
    echo -e "${BLUE}Run: git config --global user.name \"Your Name\"${NC}"
else
    echo -e "${GREEN}✓ Git user.name: $(git config --global user.name)${NC}"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo -e "${YELLOW}⚠ Git user.email not set${NC}"
    echo -e "${BLUE}Run: git config --global user.email \"your.email@example.com\"${NC}"
else
    echo -e "${GREEN}✓ Git user.email: $(git config --global user.email)${NC}"
fi
echo ""

# Step 7: Check GitHub CLI auth
echo -e "${BLUE}=== Checking GitHub CLI Authentication ===${NC}"
if gh auth status &> /dev/null; then
    echo -e "${GREEN}✓ GitHub CLI authenticated${NC}"
else
    echo -e "${YELLOW}⚠ GitHub CLI not authenticated${NC}"
    echo -e "${BLUE}Run: gh auth login${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Restart your terminal or run: ${GREEN}source ~/.zshrc${NC}"
echo -e "2. Configure Git if needed"
echo -e "3. Authenticate GitHub CLI if needed: ${GREEN}gh auth login${NC}"
echo ""
