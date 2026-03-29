---
name: env_setup
description: Complete Mac development environment setup for Claude Code
---

# Mac Development Environment Setup for Claude Code

This skill guides you through setting up a brand new Mac for optimal development with Claude Code, especially for iOS development.

## 📋 Prerequisites
- macOS (latest stable version recommended)
- Admin access to install software
- Apple ID for App Store and Xcode

## 🚀 Step-by-Step Setup

### Step 1: Create Claude Code Directory Structure
```bash
# Create personal skills folder (FIRST PRIORITY)
mkdir -p ~/.claude/skills
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/templates

# Create a working directory for projects
mkdir -p ~/Development
mkdir -p ~/Development/iOS
mkdir -p ~/Development/Scripts
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

### Step 3: Install Xcode and Command Line Tools
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Xcode from App Store (manual step)
# Open App Store → Search "Xcode" → Install (this takes time ~7GB)

# After Xcode installation, set it as active developer directory
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# Accept Xcode license
sudo xcodebuild -license accept

# Install additional components
xcodebuild -runFirstLaunch
```

### Step 4: Install Essential Development Tools
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

# Ruby (for CocoaPods)
brew install rbenv ruby-build
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
source ~/.zshrc
rbenv install 3.2.2
rbenv global 3.2.2

# Install CocoaPods for iOS development
gem install cocoapods
```

### Step 5: Install iOS Development Tools
```bash
# SwiftLint for code quality
brew install swiftlint

# SwiftFormat for code formatting
brew install swiftformat

# Carthage for dependency management
brew install carthage

# Fastlane for automation
brew install fastlane

# xcpretty for better Xcode output
gem install xcpretty

# iOS Simulator utilities
brew install ios-sim
brew install idb-companion
```

### Step 6: Install Development Utilities
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

### Step 7: Install Code Editors and IDEs
```bash
# Visual Studio Code
brew install --cask visual-studio-code

# JetBrains Toolbox (for AppCode, etc.)
brew install --cask jetbrains-toolbox

# Sublime Text
brew install --cask sublime-text

# Other useful apps for developers
brew install --cask docker
brew install --cask postman
brew install --cask sourcetree  # Git GUI
brew install --cask sf-symbols  # Apple SF Symbols
```

### Step 8: Configure Shell Environment
```bash
# Create a comprehensive .zshrc
cat >> ~/.zshrc << 'EOF'

# Claude Code Aliases
alias claude-skills="cd ~/.claude/skills"
alias claude-commands="cd ~/.claude/commands"
alias dev="cd ~/Development"
alias ios="cd ~/Development/iOS"

# Git Aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph"

# Xcode Aliases
alias xcclean="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias xcsim="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias xcopen="open *.xcworkspace || open *.xcodeproj"

# iOS Development Functions
function new-swift-project() {
    mkdir -p "$1" && cd "$1"
    swift package init --type executable
    echo "Created Swift project: $1"
}

function ios-build() {
    xcodebuild -workspace *.xcworkspace -scheme "$1" -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
}

# Development Environment
export EDITOR="code"  # or "vim" or "nano"
export PATH="$HOME/.local/bin:$PATH"

EOF

source ~/.zshrc
```

### Step 9: Set Up Claude Code Custom Commands
```bash
# Navigate to Claude commands directory
cd ~/.claude/commands

# Create a template command for new iOS projects
cat > new-ios-project.md << 'EOF'
---
description: Create a new iOS project with best practices
---

Create a new iOS project with the following structure:
1. SwiftUI app with MVVM architecture
2. Organized folder structure (Views, Models, ViewModels, Services)
3. Git repository with .gitignore
4. README with project documentation
5. Basic navigation and tab structure
6. Settings and user profile views
7. Network service layer template
8. Unit test structure
EOF
```

### Step 10: Create Development Templates
```bash
# Create iOS templates directory
mkdir -p ~/.claude/templates/ios

# Save SwiftUI view template
cat > ~/.claude/templates/ios/SwiftUIView.swift << 'EOF'
import SwiftUI

struct TemplateView: View {
    // MARK: - Properties

    // MARK: - Body
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .padding()
    }
}

// MARK: - Preview
#Preview {
    TemplateView()
}
EOF

# Save ViewModel template
cat > ~/.claude/templates/ios/ViewModel.swift << 'EOF'
import Foundation
import Combine

@MainActor
class TemplateViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        setupBindings()
    }

    // MARK: - Methods
    private func setupBindings() {
        // Set up Combine subscriptions
    }

    func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Perform async operations
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
EOF
```

### Step 11: Verify Installation
```bash
# Create verification script
cat > ~/verify_setup.sh << 'EOF'
#!/bin/bash

echo "🔍 Verifying Development Environment Setup..."
echo "==========================================="

# Check Xcode
if xcode-select -p &> /dev/null; then
    echo "✅ Xcode Command Line Tools: $(xcode-select -p)"
else
    echo "❌ Xcode Command Line Tools not installed"
fi

# Check Homebrew
if command -v brew &> /dev/null; then
    echo "✅ Homebrew: $(brew --version | head -n 1)"
else
    echo "❌ Homebrew not installed"
fi

# Check Git
if command -v git &> /dev/null; then
    echo "✅ Git: $(git --version)"
else
    echo "❌ Git not installed"
fi

# Check GitHub CLI
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI: $(gh --version | head -n 1)"
    gh auth status 2>&1 | grep -q "Logged in" && echo "  ✓ Authenticated" || echo "  ⚠ Not authenticated"
else
    echo "❌ GitHub CLI not installed"
fi

# Check Node.js
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
else
    echo "❌ Node.js not installed"
fi

# Check Ruby
if command -v ruby &> /dev/null; then
    echo "✅ Ruby: $(ruby --version | cut -d' ' -f2)"
else
    echo "❌ Ruby not installed"
fi

# Check CocoaPods
if command -v pod &> /dev/null; then
    echo "✅ CocoaPods: $(pod --version)"
else
    echo "❌ CocoaPods not installed"
fi

# Check Claude directories
echo ""
echo "📁 Claude Code Directories:"
[ -d ~/.claude/skills ] && echo "✅ ~/.claude/skills exists" || echo "❌ ~/.claude/skills missing"
[ -d ~/.claude/commands ] && echo "✅ ~/.claude/commands exists" || echo "❌ ~/.claude/commands missing"
[ -d ~/.claude/templates ] && echo "✅ ~/.claude/templates exists" || echo "❌ ~/.claude/templates missing"

echo ""
echo "==========================================="
echo "Setup verification complete!"
EOF

chmod +x ~/verify_setup.sh

# Run verification
~/verify_setup.sh
```

### Step 12: iOS-Specific Configuration
```bash
# Install iOS Simulator runtimes (if needed)
xcrun simctl list runtimes

# Download additional simulators through Xcode:
# Xcode → Settings → Platforms → Add simulators

# Set up provisioning profiles directory
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

# Configure Xcode for better performance
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
defaults write com.apple.dt.Xcode IDEIndexerActivityShowNumericProgress YES
```

### Step 13: Configure MCP (Model Context Protocol) Servers

⚠️ **IMPORTANT**: These commands must be run in a regular terminal (Terminal.app or iTerm2), **NOT** inside Claude Code.

#### What is MCP?
MCP (Model Context Protocol) allows Claude Code to connect to external data sources and services like Supabase, providing enhanced capabilities for database operations, authentication, and more.

#### Supabase MCP Setup

1. **Get your Supabase project reference:**
   - Go to your Supabase dashboard: https://supabase.com/dashboard
   - Select your project
   - Copy your Project Reference ID (found in Settings → General)

2. **Add Supabase MCP to your project** (run in regular terminal, outside Claude Code):
   ```bash
   # Navigate to your project directory first
   cd /path/to/your/project

   # Add Supabase MCP with project scope
   claude mcp add --scope project --transport http supabase "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_REF"

   # Example:
   # claude mcp add --scope project --transport http supabase "https://mcp.supabase.com/mcp?project_ref=qczbfdvlmdaflcvlkrtx"
   ```

3. **Add Supabase MCP globally** (optional, for all projects):
   ```bash
   # Run in regular terminal, outside Claude Code
   claude mcp add --scope global --transport http supabase "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_REF"
   ```

#### Other Useful MCP Servers

```bash
# All commands below should be run in a regular terminal, NOT inside Claude Code

# PostgreSQL MCP (for direct database access)
claude mcp add --scope project --transport stdio postgresql npx -y @modelcontextprotocol/server-postgres postgresql://user:password@localhost/dbname

# Filesystem MCP (for file operations)
claude mcp add --scope project --transport stdio filesystem npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/directory

# GitHub MCP (for GitHub API access)
claude mcp add --scope global --transport stdio github npx -y @modelcontextprotocol/server-github

# Brave Search MCP (for web search)
claude mcp add --scope global --transport stdio brave-search npx -y @modelcontextprotocol/server-brave-search
```

#### Verify MCP Configuration

```bash
# List all configured MCP servers (run in regular terminal)
claude mcp list

# Remove an MCP server if needed (run in regular terminal)
claude mcp remove supabase --scope project
```

#### MCP Configuration Files

- **Project scope**: `.claude/mcp.json` in your project directory
- **Global scope**: `~/.claude/mcp.json`

You can manually edit these files if needed, but it's recommended to use the CLI commands.

#### Tips for MCP Usage

1. **Project vs Global scope:**
   - Use `--scope project` for project-specific databases (recommended)
   - Use `--scope global` for services you use across all projects

2. **Security considerations:**
   - Never commit `.claude/mcp.json` with sensitive credentials to git
   - Add `.claude/mcp.json` to `.gitignore` if it contains secrets
   - Use environment variables for sensitive data when possible

3. **Restart Claude Code:**
   - After adding MCP servers, restart Claude Code to load the new configuration
   - MCP servers will be available in your next Claude Code session

## 🔧 Troubleshooting

### Common Issues and Solutions

1. **Homebrew Installation Fails**
   - Ensure you have Command Line Tools: `xcode-select --install`
   - Check macOS compatibility

2. **GitHub CLI Authentication Issues**
   - Run: `gh auth logout` then `gh auth login`
   - Choose SSH over HTTPS if having token issues

3. **CocoaPods Installation Fails**
   - Update Ruby first: `rbenv install --list` and install latest stable
   - Use sudo if needed: `sudo gem install cocoapods`

4. **Xcode Won't Set as Active Developer Directory**
   - Ensure Xcode is fully installed and opened at least once
   - Accept license: `sudo xcodebuild -license accept`

5. **MCP Server Not Working**
   - Verify configuration: `claude mcp list` (run outside Claude Code)
   - Check `.claude/mcp.json` file exists and has correct format
   - Restart Claude Code after adding MCP servers
   - Ensure you're not running MCP commands inside Claude Code itself
   - For Supabase: Verify project_ref is correct in your Supabase dashboard

## 📌 Post-Setup Recommendations

1. **Create Your First iOS Project**
   ```bash
   cd ~/Development/iOS
   mkdir MyFirstApp && cd MyFirstApp
   # Use Claude Code to generate the project structure
   ```

2. **Install Additional VS Code Extensions**
   - Swift
   - SwiftLint
   - Xcode Theme

3. **Set Up Git Credentials**
   ```bash
   git config --global credential.helper osxkeychain
   ```

4. **Configure SSH Keys for GitHub**
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   gh ssh-key add ~/.ssh/id_ed25519.pub
   ```

## ✅ Completion Checklist

- [ ] Claude Code directories created
- [ ] Homebrew installed
- [ ] Xcode and Command Line Tools installed
- [ ] Git configured with user details
- [ ] GitHub CLI authenticated
- [ ] Node.js and npm installed
- [ ] Ruby and CocoaPods installed
- [ ] iOS development tools installed
- [ ] Shell aliases configured
- [ ] Templates created
- [ ] MCP servers configured (Supabase, etc.)
- [ ] Verification script passing

Once all items are checked, your Mac is fully configured for Claude Code and iOS development!

## 💡 Tips

- Run `brew update && brew upgrade` weekly to keep tools updated
- Use `xcclean` alias when Xcode builds act strangely
- Keep your skills in `~/.claude/skills/` for all projects
- Commit your project-specific skills to git for team sharing
- Always run `claude mcp` commands in a regular terminal, not inside Claude Code
- Add `.claude/mcp.json` to `.gitignore` if it contains sensitive project references
- Use project-scoped MCP for database connections, global for general services

---

**Note**: This setup is optimized for iOS development with Claude Code. Adjust based on your specific needs.