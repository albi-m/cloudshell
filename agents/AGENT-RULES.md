# AGENT RULES — Every Agent MUST Follow These

## After completing EACH task, run this command:

```bash
# Replace TASK-ID with the actual task ID (e.g., BF-001, SC-003, TW-001)
# Replace STATUS with: in-progress, review, or done

python3 -c "
import json, datetime
f='/Users/albinmathew/Project/Termius-Alternative/agents/progress.json'
try:
    d=json.load(open(f))
except:
    d={'lastUpdated':'','tasks':{}}
d['tasks']['TASK-ID']={'status':'STATUS','completedAt':datetime.datetime.now().isoformat(),'agent':'AGENT-ID'}
d['lastUpdated']=datetime.datetime.now().isoformat()
json.dump(d,open(f,'w'),indent=2)
print('✅ Progress updated: TASK-ID → STATUS')
"
```

## Examples:

```bash
# BugFixer starts working on BF-001
python3 -c "
import json,datetime;f='/Users/albinmathew/Project/Termius-Alternative/agents/progress.json'
d=json.load(open(f));d['tasks']['BF-001']={'status':'in-progress','at':datetime.datetime.now().isoformat(),'agent':'AG-01'};d['lastUpdated']=datetime.datetime.now().isoformat()
json.dump(d,open(f,'w'),indent=2);print('✅ BF-001 → in-progress')
"

# BugFixer completes BF-001
python3 -c "
import json,datetime;f='/Users/albinmathew/Project/Termius-Alternative/agents/progress.json'
d=json.load(open(f));d['tasks']['BF-001']={'status':'done','at':datetime.datetime.now().isoformat(),'agent':'AG-01'};d['lastUpdated']=datetime.datetime.now().isoformat()
json.dump(d,open(f,'w'),indent=2);print('✅ BF-001 → done')
"
```

## CRITICAL: Add this instruction to every agent prompt

When you start Claude Code for an agent, include this in your prompt:

"After completing each task, update progress by running:
python3 agents/update-progress.py TASK-ID STATUS"
