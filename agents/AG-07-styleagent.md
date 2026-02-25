# AG-07: StyleAgent 🎨

## Mission
Enforce design system compliance, eliminate hardcoded styles, accessibility.

## Rules
- Branch: `style/agent-07-consistency`
- ALL colors → AppColors.*, ALL text styles → theme, ALL spacing → constants
- Commit: `style(AG-07): ST-XXX — description`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-07`

---

## Task ST-001 [HIGH] — Audit hardcoded colors (3h)
`grep -rn "Color(0x" lib/ui/` — Replace every instance with AppColors.* token.

## Task ST-002 [HIGH] — Audit hardcoded text styles (2h)
`grep -rn "TextStyle(" lib/ui/` — Replace with Theme.of(context).textTheme.*

## Task ST-003 [MEDIUM] — Audit hardcoded spacing (2h)
Find magic numbers in EdgeInsets, SizedBox, Padding. Use spacing constants.

## Task ST-004 [HIGH] — Accessibility audit (4h)
Semantics labels, color contrast 4.5:1, screen reader support, focus order.

## Task ST-005 [MEDIUM] — Responsive breakpoint audit (2h)
Every screen uses LayoutBuilder/MediaQuery. No hardcoded widths.

## Task ST-006 [MEDIUM] — Touch target audit (1h)
All interactive elements ≥ 44x44px on mobile.

## Task ST-007 [MEDIUM] — Dark mode verification (2h)
Every screen correct in dark mode. No contrast issues.