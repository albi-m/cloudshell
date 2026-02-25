# AG-04: RefactorBot Agent ♻️

## Mission
Improve code quality, reduce complexity, consistent patterns.

## Rules
- Branch: `refactor/agent-04-quality`
- NEVER change behavior — only structure
- Run tests after EVERY change
- Commit: `refactor(AG-04): RF-XXX — description`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-04`

---

## Task RF-001 [HIGH] — Split settings_screen.dart / 2411 lines (3h)
Split into: appearance_section, security_section, sync_section, terminal_section, about_section, connection_section, import_export_section + shared widgets (settings_tile, settings_section_header, settings_toggle)

## Task RF-002 [MEDIUM] — Extract shared SSH connection logic (2h)
Create ConnectionManager from duplicated logic in ssh_service.dart and sftp_service.dart.

## Task RF-003 [MEDIUM] — Remove dead code and unused imports (1.5h)
Run `dart analyze lib/`. Remove all dead code, unused imports, unused variables.

## Task RF-004 [LOW] — Add const constructors everywhere (2h)
Audit all widget constructors. Add const where possible.

## Task RF-005 [MEDIUM] — Flatten deeply nested code (2h)
Find 3+ nesting levels. Use early returns, guard clauses, extract helpers.

## Task RF-006 [MEDIUM] — Consistent error handling pattern (2h)
Define AppException hierarchy. Replace catch (_) with typed catches. Expose error states to UI.