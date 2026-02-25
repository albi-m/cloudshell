#!/usr/bin/env python3
"""Update agent progress tracker. Usage: python3 update-progress.py TASK-ID STATUS [AGENT-ID]"""
import json, sys, datetime, os

PROGRESS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'progress.json')

def update(task_id, status, agent_id="unknown"):
    try:
        with open(PROGRESS_FILE, 'r') as f:
            data = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        data = {"lastUpdated": "", "tasks": {}}
    
    data["tasks"][task_id] = {
        "status": status,
        "agent": agent_id,
        "updatedAt": datetime.datetime.now().isoformat()
    }
    data["lastUpdated"] = datetime.datetime.now().isoformat()
    
    with open(PROGRESS_FILE, 'w') as f:
        json.dump(data, f, indent=2)
    
    icon = {"todo":"⬜","in-progress":"🔵","review":"🟡","done":"✅"}.get(status,"❓")
    print(f"{icon} {task_id} → {status}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 update-progress.py TASK-ID STATUS [AGENT-ID]")
        print("  STATUS: todo | in-progress | review | done")
        print("  Example: python3 update-progress.py BF-001 done AG-01")
        sys.exit(1)
    update(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else "unknown")