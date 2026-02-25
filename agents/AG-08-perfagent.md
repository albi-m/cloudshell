# AG-08: PerfAgent ⚡

## Mission
Optimize performance across all platforms.

## Rules
- Branch: `perf/agent-08-optimization`
- Measure BEFORE and AFTER every change
- Don't sacrifice readability for micro-optimizations
- Commit: `perf(AG-08): PF-XXX — description`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-08`

---

## Task PF-001 [MEDIUM] — Audit ListView usage (1.5h)
Replace ListView() with ListView.builder() everywhere.

## Task PF-002 [HIGH] — Terminal rendering performance (3h)
Profile with DevTools. Measure FPS with heavy output. Target: 30+ FPS sustained.

## Task PF-003 [HIGH] — Memory leak audit (2h)
Check all StreamSubscriptions cancelled, Controllers disposed, Timers cancelled.

## Task PF-004 [LOW] — Build size optimization (2h)
`flutter build --analyze-size` per platform. Remove unused assets. Optimize images.

## Task PF-005 [LOW] — Add const constructors (1.5h)
Add const to every constructor and literal possible.