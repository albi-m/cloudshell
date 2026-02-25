# AG-05: DocWriter Agent 📝

## Mission
Comprehensive documentation and code comments.

## Rules
- Branch: `docs/agent-05-documentation`
- Doc comments use `///` (dartdoc format)
- Comments explain WHY, not WHAT
- Commit: `docs(AG-05): DC-XXX — description`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-05`

---

## Task DC-001 [HIGH] — Doc comments for all public classes (6h)
160 files. Every public class needs /// doc comment. Every public method needs @param/@return.

## Task DC-002 [MEDIUM] — Inline comments for complex algorithms (3h)
Add WHY comments to: vault_crypto_service, ssh_service, telnet_parser, sftp_service, ppk_parser

## Task DC-003 [HIGH] — Create ARCHITECTURE.md (2h)
Layer diagram, data flow, state management, dependency graph.

## Task DC-004 [MEDIUM] — Create RESPONSIVE.md (1.5h)
Breakpoints, platform layouts, AdaptiveBuilder pattern.

## Task DC-005 [MEDIUM] — Create TESTING.md (1h)
Test strategy, coverage goals, how to run per platform.

## Task DC-006 [HIGH] — Update README.md (2h)
Setup per platform, architecture overview, screenshots, build commands.

## Task DC-007 [LOW] — Clean TODO/FIXME comments (1h)
Remove resolved, add issue numbers to remaining.

## Task DC-008 [LOW] — Generate API docs with dartdoc (1h)
Run `dart doc`, fix all warnings.