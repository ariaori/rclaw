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

## 📱 iOS Development Setup (Optional)

**For iOS app development**, you need Xcode installed. This MUST be done manually as Xcode requires App Store installation.

### Setup Steps (Run Outside Claude Code)

```bash
# 1. Install Xcode from Mac App Store (~7GB download, requires Apple ID)
# Open App Store → Search "Xcode" → Install

# 2. After Xcode installation, configure command line tools
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 3. Accept Xcode license
sudo xcodebuild -license accept

# 4. Install additional components
xcodebuild -runFirstLaunch
```

### Verification (For Claude Code)

When the user asks to verify iOS setup, run these commands:

```bash
# Check if Xcode is installed
xcode-select -p

# Check Xcode version
xcodebuild -version

# List available iOS simulators
xcrun simctl list devices available
```

**Report Format**: If Xcode is not installed, remind the user that iOS development requires full Xcode from the App Store. Command Line Tools alone are NOT sufficient for iOS app development.

---

## 📋 Prerequisites
- macOS (latest stable version recommended)
- Admin access to install software