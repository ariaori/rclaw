---
name: skills
description: List and manage all personal Claude Code skills
---

# Skills Management

This skill helps you list, view, and manage all your personal Claude Code skills.

## 📋 List All Skills

First, let me show you all available skills in your personal `.claude` directory:

### Global Skills (~/.claude/skills/)
```bash
# List all global skills
ls -1 ~/.claude/skills/*.md | xargs -I {} basename {} .md

# List with descriptions
for file in ~/.claude/skills/*.md; do
    name=$(basename "$file" .md)
    desc=$(grep "^description:" "$file" | cut -d':' -f2- | xargs)
    echo "• $name - $desc"
done
```

### Project Skills (.claude/skills/)
```bash
# List project-specific skills (if in a project directory)
ls -1 .claude/skills/*.md 2>/dev/null | xargs -I {} basename {} .md

# List with descriptions
for file in .claude/skills/*.md 2>/dev/null; do
    name=$(basename "$file" .md)
    desc=$(grep "^description:" "$file" | cut -d':' -f2- | xargs)
    echo "• $name - $desc"
done
```