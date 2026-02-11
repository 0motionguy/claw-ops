#!/usr/bin/env python3
"""
Context Compressor for OpenClaw
Summarizes old sessions and removes redundant content
"""

import json
import re
import sys
from pathlib import Path
from datetime import datetime, timedelta
from typing import List, Dict, Any

class ContextCompressor:
    def __init__(self, workspace_dir: str = "~/.openclaw/workspace"):
        self.workspace = Path(workspace_dir).expanduser()
        self.memory_dir = self.workspace / "memory"
        self.sessions_dir = Path("~/.openclaw/agents/main/sessions").expanduser()
        self.compression_ratio = 0.3  # Target 30% of original size
        
    def compress_session(self, session_file: Path) -> Dict[str, Any]:
        """Compress a session file to key decisions only"""
        try:
            with open(session_file, 'r') as f:
                lines = f.readlines()
        except Exception as e:
            print(f"Error reading {session_file}: {e}")
            return {}
        
        # Parse JSONL
        messages = []
        for line in lines:
            try:
                msg = json.loads(line.strip())
                messages.append(msg)
            except json.JSONDecodeError:
                continue
        
        if not messages:
            return {}
        
        # Extract key information
        summary = {
            "timestamp": messages[0].get("timestamp", ""),
            "session_key": messages[0].get("sessionKey", ""),
            "message_count": len(messages),
            "key_decisions": [],
            "tools_used": set(),
            "files_modified": set(),
            "outcome": ""
        }
        
        # Find tool usages
        for msg in messages:
            if msg.get("role") == "assistant":
                content = msg.get("content", "")
                
                # Extract tool calls
                tool_matches = re.findall(r'(\w+)\([^)]*\)', content)
                summary["tools_used"].update(tool_matches)
                
                # Extract file modifications
                file_matches = re.findall(r'`([^`]+\.(?:py|sh|md|json|js|ts))`', content)
                summary["files_modified"].update(file_matches)
                
                # Look for completion indicators
                if any(word in content.lower() for word in ["completed", "done", "finished", "✅"]):
                    summary["outcome"] = "completed"
                    # Keep last completion message
                    summary["key_decisions"].append({
                        "type": "completion",
                        "content": content[:500]  # First 500 chars
                    })
        
        # Convert sets to lists for JSON serialization
        summary["tools_used"] = list(summary["tools_used"])
        summary["files_modified"] = list(summary["files_modified"])
        
        return summary
    
    def compress_memory_file(self, memory_file: Path) -> str:
        """Compress a memory markdown file"""
        try:
            with open(memory_file, 'r') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading {memory_file}: {e}")
            return ""
        
        # Extract key sections
        sections = re.split(r'\n##+ ', content)
        
        compressed = []
        for section in sections[:3]:  # Keep first 3 sections
            lines = section.strip().split('\n')
            # Keep headings and bullet points only
            important = [l for l in lines if l.startswith('#') or l.startswith('-') or l.startswith('*')]
            compressed.append('\n'.join(important[:20]))  # Max 20 lines per section
        
        return '\n\n'.join(compressed)
    
    def archive_old_sessions(self, days_old: int = 7) -> int:
        """Archive sessions older than N days"""
        archive_dir = self.sessions_dir / "archive"
        archive_dir.mkdir(exist_ok=True)
        
        cutoff = datetime.now() - timedelta(days=days_old)
        archived = 0
        
        for session_file in self.sessions_dir.glob("*.jsonl"):
            try:
                stat = session_file.stat()
                file_time = datetime.fromtimestamp(stat.st_mtime)
                
                if file_time < cutoff:
                    # Compress first
                    summary = self.compress_session(session_file)
                    if summary:
                        summary_file = archive_dir / f"{session_file.stem}.summary.json"
                        with open(summary_file, 'w') as f:
                            json.dump(summary, f, indent=2)
                    
                    # Move original to archive
                    session_file.rename(archive_dir / session_file.name)
                    archived += 1
            except Exception as e:
                print(f"Error archiving {session_file}: {e}")
        
        return archived
    
    def clean_redundant_tool_outputs(self, content: str) -> str:
        """Remove redundant tool outputs from content"""
        # Patterns for redundant outputs
        patterns = [
            (r'\n```\n\(no output recorded\)\n```\n', ''),  # Empty outputs
            (r'\n```\nCommand exited with code \d+\n```\n', ''),  # Exit codes only
            (r'\n```\n\(process still running\)\n```\n', ''),  # Hanging processes
        ]
        
        for pattern, replacement in patterns:
            content = re.sub(pattern, replacement, content, flags=re.IGNORECASE)
        
        return content
    
    def generate_index(self) -> Dict[str, Any]:
        """Generate searchable index of all memories and sessions"""
        index = {
            "generated_at": datetime.now().isoformat(),
            "memories": [],
            "sessions": [],
            "skills": [],
            "total_tokens_estimate": 0
        }
        
        # Index memory files
        for mem_file in self.memory_dir.glob("*.md"):
            try:
                stat = mem_file.stat()
                index["memories"].append({
                    "file": str(mem_file.name),
                    "date": datetime.fromtimestamp(stat.st_mtime).isoformat(),
                    "size_bytes": stat.st_size,
                    "tokens_estimate": stat.st_size // 4  # Rough estimate
                })
                index["total_tokens_estimate"] += stat.st_size // 4
            except Exception as e:
                print(f"Error indexing {mem_file}: {e}")
        
        # Index active sessions
        for session_file in self.sessions_dir.glob("*.jsonl"):
            try:
                stat = session_file.stat()
                index["sessions"].append({
                    "file": str(session_file.name),
                    "date": datetime.fromtimestamp(stat.st_mtime).isoformat(),
                    "size_bytes": stat.st_size,
                    "tokens_estimate": stat.st_size // 4
                })
                index["total_tokens_estimate"] += stat.st_size // 4
            except Exception as e:
                print(f"Error indexing {session_file}: {e}")
        
        return index
    
    def run_maintenance(self):
        """Run full maintenance routine"""
        print("🧹 Running Context Compressor Maintenance...")
        print()
        
        # 1. Archive old sessions
        print("📦 Archiving old sessions (7+ days)...")
        archived = self.archive_old_sessions(days_old=7)
        print(f"   Archived {archived} sessions")
        print()
        
        # 2. Generate index
        print("📋 Generating search index...")
        index = self.generate_index()
        index_file = self.workspace / "memory_index.json"
        with open(index_file, 'w') as f:
            json.dump(index, f, indent=2)
        print(f"   Index saved to: {index_file}")
        print(f"   Total tokens estimated: {index['total_tokens_estimate']:,}")
        print()
        
        # 3. Summary
        print("✅ Maintenance complete!")
        print(f"   Memories indexed: {len(index['memories'])}")
        print(f"   Active sessions: {len(index['sessions'])}")
        print(f"   Archived sessions: {archived}")

if __name__ == "__main__":
    compressor = ContextCompressor()
    
    if len(sys.argv) > 1 and sys.argv[1] == "--compress":
        # Compress specific file
        if len(sys.argv) > 2:
            file_path = Path(sys.argv[2])
            if file_path.exists():
                summary = compressor.compress_session(file_path)
                print(json.dumps(summary, indent=2))
            else:
                print(f"File not found: {file_path}")
    else:
        # Run full maintenance
        compressor.run_maintenance()
