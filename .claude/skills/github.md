---
name: github
description: GitHub CLI quick reference - most used commands at a glance
---

# GitHub CLI Quick Reference

## 🚀 Most Used Commands

### Authentication

**IMPORTANT**: `gh auth login` is an interactive command that requires user action. Claude cannot complete it automatically.

#### Check Authentication Status First
```bash
gh auth status                    # Check if logged in and token is valid
```

#### Authentication Flow
When you need to authenticate:
1. **Claude will run**: `gh auth login` (this will pause for user input)
2. **User action required**:
   - Copy the one-time code displayed (e.g., BB05-6B74)
   - Open the URL in browser: https://github.com/login/device
   - Paste the code and authorize
3. **Claude continues**: After authorization completes

#### Troubleshooting
```bash
gh auth logout                    # Logout current account
gh auth logout -u username        # Logout specific account
gh auth refresh                   # Refresh expired token
gh auth status                    # Verify authentication
```

#### Best Practice for Claude Code
- Always check `gh auth status` first before running other gh commands
- If authentication is needed, inform the user that manual action is required
- Wait for user confirmation before continuing with GitHub operations

### Repository
```bash
gh repo create my-app --public --clone    # Create & clone new repo
gh repo clone owner/repo                  # Clone existing repo
gh repo view --web                        # Open repo in browser
gh repo fork owner/repo --clone           # Fork and clone
```

### Pull Requests
```bash
gh pr create                      # Create PR (interactive)
gh pr create --fill              # Create PR with commit info
gh pr list                       # List open PRs
gh pr list --author @me          # List my PRs
gh pr checkout 123               # Checkout PR #123
gh pr view 123                   # View PR details
gh pr merge 123 --squash         # Squash merge PR
gh pr review 123 --approve       # Approve PR
```

### Issues
```bash
gh issue create                   # Create issue (interactive)
gh issue list                    # List open issues
gh issue list --assignee @me     # List my issues
gh issue view 456                # View issue #456
gh issue close 456               # Close issue
gh issue comment 456 --body "Fixed!"  # Comment on issue
```

### Workflows
```bash
gh workflow list                  # List workflows
gh workflow run deploy.yml        # Trigger workflow
gh run list                      # List recent runs
gh run watch                     # Watch latest run
gh run view 789 --log            # View run logs
```

### Releases
```bash
gh release create v1.0.0 --generate-notes  # Create release
gh release list                            # List releases
gh release download v1.0.0                 # Download assets
```

## ⚡ Power User Combos

```bash
# Create PR from current branch
git push -u origin HEAD && gh pr create --fill

# Quick PR review and merge
gh pr checkout 123 && npm test && gh pr review 123 --approve && gh pr merge 123 --squash

# Self-assign and start work on issue
gh issue edit 456 --add-assignee @me && gh issue develop 456

# Check all my pending work
gh pr list --author @me && gh issue list --assignee @me

# Watch CI for latest push
git push && gh run watch
```

## 🎯 Useful Aliases to Set

```bash
gh alias set co 'pr checkout'
gh alias set prs 'pr list --author @me'
gh alias set issues 'issue list --assignee @me'
gh alias set review 'pr list --search "is:pr is:open review-requested:@me"'
gh alias set status 'pr status && issue status'
```

## 🔥 Flags to Remember

- `--web` - Open in browser
- `--json` - JSON output for scripting
- `--limit N` - Limit results
- `--author @me` - Filter by yourself
- `--assignee @me` - Assigned to you
- `--label bug` - Filter by label
- `--state open/closed/merged` - Filter by state

## 💡 Tips

1. Use `gh <command> --help` for any command
2. Most commands work in repo directory
3. Use `@me` to refer to yourself
4. Add `--web` to open anything in browser
5. Use `gh api` for custom API calls

## ⚠️ Before You Start

```bash
# Always check authentication status first
gh auth status

# If not authenticated or token expired:
# 1. Run: gh auth login
# 2. Copy the one-time code (e.g., BB05-6B74)
# 3. Open https://github.com/login/device in browser
# 4. Enter code and authorize
# 5. Return to terminal - authentication complete
```

**Note**: Authentication is interactive and requires user action. Claude will pause and wait for you to complete the browser authorization.