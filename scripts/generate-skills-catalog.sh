#!/bin/bash
# Auto-document all skills

OUTPUT="/Users/andy/.openclaw/workspace/claw-ops/docs/SKILLS_CATALOG.md"

echo "# CLAW Skills Catalog" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "**Generated:** $(date)" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "| Skill | Description | Status |" >> "$OUTPUT"
echo "|-------|-------------|--------|" >> "$OUTPUT"

for skill_dir in /Users/andy/.openclaw/workspace/skills/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        
        # Extract description from SKILL.md if exists
        if [ -f "$skill_dir/SKILL.md" ]; then
            desc=$(head -10 "$skill_dir/SKILL.md" | grep -E "^# |description" | head -1 | sed 's/# //' | sed 's/description: //')
            [ -z "$desc" ] && desc="OpenClaw skill"
        else
            desc="No description"
        fi
        
        # Check if packaged
        if [ -f "/Users/andy/.openclaw/workspace/skills/${skill_name}.skill" ]; then
            status="✅ Packaged"
        else
            status="📦 Unpackaged"
        fi
        
        echo "| $skill_name | $desc | $status |" >> "$OUTPUT"
    fi
done

echo "" >> "$OUTPUT"
echo "**Total: $(ls -d /Users/andy/.openclaw/workspace/skills/*/ | wc -l) skills**" >> "$OUTPUT"
