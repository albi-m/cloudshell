# CloudShell Multi-Agent Quality Fix — Master Plan

## Project: CloudShell (Termius Alternative)
**Codebase:** 160 files • 72,901 lines • Flutter/Dart
**Current Test Coverage:** ~5% (7 test files)
**Target:** Production-ready with 80%+ coverage, zero critical issues

---

## 📊 Issue Inventory (from ANALYSIS-REPORT.md + Quality Audit)

| Category | Critical | High | Medium | Low | Total |
|----------|----------|------|--------|-----|-------|
| Bugs | 1 | 2 | 1 | 1 | 5 |
| Security | 1 | 3 | 2 | 1 | 7 |
| Testing | 2 | 3 | 3 | 0 | 8 |
| Refactoring | 0 | 2 | 3 | 1 | 6 |
| Documentation | 0 | 3 | 3 | 2 | 8 |
| Package Upgrades | 0 | 2 | 3 | 1 | 6 |
| UI/Styling | 0 | 2 | 4 | 1 | 7 |
| Performance | 0 | 2 | 1 | 2 | 5 |
| **TOTAL** | **4** | **19** | **20** | **9** | **52** |

---

## 🤖 Agent Assignments

### AG-01: BugFixer 🐛
Focus: Critical bugs from ANALYSIS-REPORT | Tasks: 5 | Estimated: 6h

### AG-02: SecurityAgent 🔒
Focus: Security hardening, vulnerability scanning | Tasks: 7 | Estimated: 10.5h

### AG-03: TestWriter 🧪
Focus: Unit, widget, integration, golden tests | Tasks: 8 | Estimated: 39h

### AG-04: RefactorBot ♻️
Focus: Code quality, complexity reduction | Tasks: 6 | Estimated: 12.5h

### AG-05: DocWriter 📝
Focus: Documentation, comments, API docs | Tasks: 8 | Estimated: 17.5h

### AG-06: UpgradeBot ⬆️
Focus: Package version upgrades | Tasks: 6 | Estimated: 18h

### AG-07: StyleAgent 🎨
Focus: UI consistency, design system, a11y | Tasks: 7 | Estimated: 16h

### AG-08: PerfAgent ⚡
Focus: Performance optimization | Tasks: 5 | Estimated: 10h

---

## 📅 Execution Phases

### Phase 1: Critical Fixes (Day 1-2)
**Agents:** 🐛 BugFixer + 🔒 SecurityAgent (PARALLEL)

```
Terminal 1: cd /Users/albinmathew/Project/Termius-Alternative && claude
            → Read agents/AG-01-bugfixer.md and execute all tasks

Terminal 2: cd /Users/albinmathew/Project/Termius-Alternative && claude
            → Read agents/AG-02-security.md and execute all tasks
```

**Gate:** All CRITICAL bugs fixed. Semgrep scan clean.

### Phase 2: Foundation (Day 2-4)
**Agents:** 🧪 TestWriter + ♻️ RefactorBot (PARALLEL)

**Gate:** Core services have tests. Settings screen split. Dead code removed.

### Phase 3: Upgrades + Style (Day 4-6)
**Agents:** ⬆️ UpgradeBot + 🎨 StyleAgent (PARALLEL)

**Gate:** Major packages upgraded. Tests still pass. No hardcoded colors/styles.

### Phase 4: Polish (Day 6-8)
**Agents:** 📝 DocWriter + ⚡ PerfAgent + 🧪 TestWriter (PARALLEL)

**Gate:** All public APIs documented. No memory leaks. Widget tests exist.

### Phase 5: Final QA (Day 8-10)
All agents converge for remaining LOW items and final verification.

```
flutter test --coverage
dart analyze
dart doc
semgrep --config=auto lib/
```

**Gate:** 80%+ coverage. Zero analyzer warnings. Docs complete.

---

## 🔗 Task Dependencies

```
BF-001 (biometric fix) ──► BF-004 (rate limiting) ──► UP-005 (local_auth upgrade)
                       └──► TW-002 (lock tests)

BF-003 (host key fix) ──► TW-003 (SSH tests)

RF-001 (split settings) ──► DC-001 (doc comments)
RF-002 (extract connection) ──► DC-003 (architecture doc)

TW-004 (provider tests) ──► UP-001 (riverpod 3.x)
                        └──► UP-002 (go_router 17.x)
```

---

## ✅ Definition of Done

- [ ] Zero CRITICAL issues
- [ ] Zero HIGH issues
- [ ] Test coverage ≥ 80% on services + providers
- [ ] Widget tests for all screens
- [ ] Golden tests for visual regression
- [ ] All public classes/methods have doc comments
- [ ] ARCHITECTURE.md, TESTING.md, RESPONSIVE.md created
- [ ] README.md updated
- [ ] All major packages at latest version
- [ ] Semgrep clean scan
- [ ] `dart analyze` zero warnings
- [ ] No hardcoded colors, text styles, or magic numbers
- [ ] Accessibility: all interactive widgets have semantic labels
- [ ] No memory leaks, ListView.builder everywhere
- [ ] Terminal FPS ≥ 30 with heavy output