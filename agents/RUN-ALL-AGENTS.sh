# CloudShell Agent Swarm — Complete Run Commands (WITH PLUGINS)
# ================================================================
# Uses: Superpowers, Deep Implement, Code Review, Code Simplifier,
#       Elements of Style, Context7, Semgrep, Playwright
# ================================================================

# ============================================================
# STEP 0: Open Dashboard in browser
# ============================================================
open /Users/albinmathew/Project/Termius-Alternative/agents/dashboard.html


# ============================================================
# PHASE 1A: 🐛 BugFixer (Terminal 1)
# Uses: Superpowers (TDD planning + execution)
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-01-bugfixer.md completely.

You are AG-01 BugFixer. Use the Superpowers plugin for structured execution.

STEP 1: Create branch
git checkout -b fix/agent-01-bugs

STEP 2: Plan all fixes
/superpowers:write-plan

Plan to fix these 5 bugs in order. For each bug, write the test FIRST (TDD), then implement the fix:
1. BF-001 [CRITICAL] Fix biometric lock grace period — add Timer-based grace period in AppLockNotifier, update app.dart lifecycle, add settings option
2. BF-002 [HIGH] Fix silent error swallowing — find all catch (_) {} and replace with proper logging
3. BF-003 [HIGH] Fix quickConnect auto-accepts host keys — show verification dialog
4. BF-004 [MEDIUM] Rate limiting on biometric failures — exponential backoff
5. BF-005 [LOW] Verify RadioGroup<T> widget — check if custom or dependency

After each task run: python3 agents/update-progress.py TASK-ID done AG-01
After each task run: flutter analyze && flutter test
After each task: git add -A && git commit -m "fix(AG-01): TASK-ID — description"

STEP 3: Execute
/superpowers:execute-plan

# ─────────────────────────────────────────────


# ============================================================
# PHASE 1B: 🔒 SecurityAgent (Terminal 2 — simultaneously)
# Uses: Semgrep MCP + Superpowers
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-02-security.md completely.

You are AG-02 SecurityAgent. Use Superpowers for structured execution and Semgrep for scanning.

STEP 1: Setup
git checkout -b security/agent-02-hardening
mkdir -p review

STEP 2: Plan
/superpowers:write-plan

Security audit plan for CloudShell SSH client:
1. SC-001 [CRITICAL] Audit SSH key storage — read lib/services/crypto/ and lib/services/ssh/ssh_key_service.dart. Check SecureStorage usage, no plaintext logging, backup exclusion, clipboard safety
2. SC-003 [HIGH] Run Semgrep — execute: semgrep --config=auto lib/ and semgrep --config=p/secrets . — fix all findings
3. SC-004 [HIGH] Input validation — audit all user inputs: hostname, port, username, SFTP paths, snippet variables. Add validation in lib/core/utils/validators.dart
4. SC-005 [HIGH] Network security — check ios/Runner/Info.plist (ATS), android/app/src/main/AndroidManifest.xml (cleartext), macos/*.entitlements (sandbox)
5. SC-006 [MEDIUM] Dependency CVE scan — run flutter pub outdated, check dartssh2/cryptography/pointycastle for CVEs
6. SC-002 [LOW] Add PBKDF2 comment in vault_crypto_service.dart explaining 1-iteration rationale
7. SC-007 [MEDIUM] Document all trade-offs in SECURITY.md

Save all findings to review/SECURITY-AUDIT.md
After each task: python3 agents/update-progress.py TASK-ID done AG-02
After each task: git add -A && git commit -m "security(AG-02): TASK-ID — description"

STEP 3: Execute
/superpowers:execute-plan

# ─────────────────────────────────────────────


# ============================================================
# PHASE 1 DONE — Merge
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative
git checkout main
git merge fix/agent-01-bugs --no-edit
git merge security/agent-02-hardening --no-edit


# ============================================================
# PHASE 2A: 🧪 TestWriter (Terminal 1)
# Uses: Deep Implement (TDD-first development)
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-03-testwriter.md completely.

You are AG-03 TestWriter. Use the Deep Implement plugin for TDD workflow.

STEP 1: Setup
git checkout -b test/agent-03-coverage
flutter pub add --dev mocktail

STEP 2: For each test task, use Deep Implement:

/deep-implement

Implement tests for CloudShell in TDD style. Write tests FIRST, then verify they compile. Execute in this order:

TASK TW-001 [CRITICAL]: Unit tests for VaultCryptoService
- File: test/services/crypto/vault_crypto_test.dart
- Tests: encrypt/decrypt cycle, key derivation consistency, HMAC tamper detection, wrong password fails, unique IVs

TASK TW-002 [CRITICAL]: Unit tests for AppLockNotifier
- File: test/providers/app_lock_provider_test.dart
- Tests: lock/unlock, grace period timer, biometric auth, rate limiting

TASK TW-003 [HIGH]: Unit tests for SshService
- File: test/services/ssh/ssh_service_test.dart
- Tests: connect, auth types (password/key/keyboard-interactive), host key verify, disconnect, max connections

TASK TW-004 [HIGH]: Unit tests for all 17 Providers
- Files: test/providers/ (one test file per provider)
- Priority: host_provider, connection_provider, terminal_tab_provider, vault_provider, sync_provider

TASK TW-005 [HIGH]: Widget tests for all screens
- Files: test/ui/ (one test file per screen)
- Test: renders, interactions, error states, empty states, loading states

TASK TW-006 [MEDIUM]: Golden tests
- File: test/goldens/
- Mobile (390x844) + Desktop (1440x900) viewports for: login, hosts, terminal, settings

TASK TW-007 [MEDIUM]: Integration tests
- File: integration_test/
- Flows: auth, vault, settings, navigation

TASK TW-008 [MEDIUM]: Coverage target 80%
- Run: flutter test --coverage
- Fill gaps in lowest-coverage files

After each task: python3 agents/update-progress.py TASK-ID done AG-03
After each task: git add -A && git commit -m "test(AG-03): TASK-ID — description"

# ─────────────────────────────────────────────


# ============================================================
# PHASE 2B: ♻️ RefactorBot (Terminal 2 — simultaneously)
# Uses: Code Review (analyze before) + Code Simplifier (simplify)
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-04-refactorbot.md completely.

You are AG-04 RefactorBot. Use Code Review and Code Simplifier plugins.

STEP 1: Setup
git checkout -b refactor/agent-04-quality

STEP 2: First, analyze the codebase:
/code-review

Review lib/ for: architecture issues, code duplication, dead code, complex functions, inconsistent patterns. Focus on the 6 tasks in my plan.

STEP 3: Then simplify:
/code-simplifier

Scan lib/ and simplify: functions > 30 lines, nesting > 3 levels, repeated patterns, complex conditionals, deep widget trees.

STEP 4: Execute refactoring tasks in order:

TASK RF-001 [HIGH]: Split settings_screen.dart (2411 lines)
→ Create lib/ui/settings/sections/ with: appearance_section.dart, security_section.dart, sync_section.dart, terminal_section.dart, about_section.dart
→ Create lib/ui/settings/widgets/ with: settings_tile.dart, settings_section_header.dart
→ Main settings_screen.dart becomes thin coordinator (~100 lines)

TASK RF-002 [MEDIUM]: Extract ConnectionManager
→ Create lib/services/connection/connection_manager.dart
→ Move shared logic from ssh_service.dart and sftp_service.dart

TASK RF-003 [MEDIUM]: Remove dead code
→ Run: dart analyze lib/ 2>&1 | grep -E "unused_import|dead_code|unused_local"
→ Fix ALL findings

TASK RF-006 [MEDIUM]: Consistent error handling
→ Extend lib/core/errors/app_exception.dart
→ Replace all catch (_) with typed catches

TASK RF-005 [MEDIUM]: Flatten nesting
→ Find 3+ nesting levels, use early returns and guard clauses

TASK RF-004 [LOW]: Add const constructors
→ Fix all prefer_const_constructors warnings

After each task: flutter analyze && flutter test (MUST pass)
After each task: python3 agents/update-progress.py TASK-ID done AG-04
After each task: git add -A && git commit -m "refactor(AG-04): TASK-ID — description"

# ─────────────────────────────────────────────


# ============================================================
# PHASE 2 DONE — Merge
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative
git checkout main
git merge test/agent-03-coverage --no-edit
git merge refactor/agent-04-quality --no-edit


# ============================================================
# PHASE 3A: ⬆️ UpgradeBot (Terminal 1)
# Uses: Context7 (fetches latest API docs for each package)
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-06-upgradebot.md completely.

You are AG-06 UpgradeBot. Use Context7 to look up the latest API docs and migration guides for each package before upgrading.

STEP 1: Setup
git checkout -b upgrade/agent-06-packages

STEP 2: For each upgrade, use this workflow:
a) Use Context7 to fetch the migration guide for the package
b) Update pubspec.yaml
c) Run flutter pub get
d) Fix all breaking API changes based on the migration guide
e) Run dart run build_runner build --delete-conflicting-outputs (if needed for riverpod/drift)
f) Run flutter analyze (zero warnings)
g) Run flutter test (all must pass)

TASK UP-001 [HIGH]: flutter_riverpod 2.x → 3.x
→ Use Context7 to look up riverpod 3.x migration guide
→ Also upgrade: riverpod_annotation, riverpod_generator
→ Update ALL 17 provider files in lib/providers/
→ Regenerate with build_runner

TASK UP-002 [HIGH]: go_router 14.x → 17.x
→ Use Context7 to look up go_router 17.x migration guide
→ Update lib/router/app_router.dart

TASK UP-003 [MEDIUM]: dartssh2 2.9 → 2.12
→ Test all SSH connection types after upgrade

TASK UP-004 [MEDIUM]: drift 2.22 → 2.31
→ Regenerate all .g.dart files
→ Run all DAO tests

TASK UP-005 [MEDIUM]: local_auth 2.x → 3.x
→ Update biometric API calls in app_lock_provider.dart

TASK UP-006 [LOW]: Remaining packages
→ google_fonts 6→8, share_plus 10→11, connectivity_plus 6→7, pointycastle 3→4

After each task: python3 agents/update-progress.py TASK-ID done AG-06
After each task: git add -A && git commit -m "deps(AG-06): TASK-ID — upgrade X → Y"

# ─────────────────────────────────────────────


# ============================================================
# PHASE 3B: 🎨 StyleAgent (Terminal 2 — simultaneously)
# Uses: Code Review (find violations) + Superpowers
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-07-styleagent.md completely.

You are AG-07 StyleAgent. Use Code Review to find style violations, then fix them.

STEP 1: Setup
git checkout -b style/agent-07-consistency

STEP 2: First scan for violations:
/code-review

Review lib/ui/ specifically for:
- Hardcoded colors (Color(0x...) not using AppColors)
- Hardcoded text styles (TextStyle() not using theme)
- Magic numbers in spacing/sizing
- Missing Semantics labels on interactive widgets
- Hardcoded widths that break responsiveness
- Touch targets < 44x44px
- Dark mode issues

STEP 3: Fix each category:

/superpowers:write-plan

Fix all UI consistency issues:

TASK ST-001 [HIGH]: Fix hardcoded colors
→ grep -rn "Color(0x" lib/ui/ and grep -rn "Colors\." lib/ui/ | grep -v AppColors
→ Replace EVERY instance with AppColors.* token

TASK ST-002 [HIGH]: Fix hardcoded text styles
→ grep -rn "TextStyle(" lib/ui/
→ Replace with Theme.of(context).textTheme.* or AppTypography.*

TASK ST-003 [MEDIUM]: Fix hardcoded spacing
→ Find magic numbers in EdgeInsets, SizedBox, Padding
→ Create spacing constants if not exists, use them

TASK ST-004 [HIGH]: Accessibility
→ Add Semantics(label:) to every IconButton, GestureDetector, InkWell
→ Check color contrast ratios (use online checker)
→ Verify focus traversal order

TASK ST-005 [MEDIUM]: Responsive breakpoints
→ Find hardcoded widths/heights in lib/ui/
→ Replace with MediaQuery or LayoutBuilder

TASK ST-006 [MEDIUM]: Touch targets
→ Ensure SizedBox(width:44,height:44) minimum on all interactive mobile widgets

TASK ST-007 [MEDIUM]: Dark mode
→ Test every screen, fix any white backgrounds, invisible text, contrast issues

/superpowers:execute-plan

After each task: python3 agents/update-progress.py TASK-ID done AG-07
After each task: git add -A && git commit -m "style(AG-07): TASK-ID — description"

# ─────────────────────────────────────────────


# ============================================================
# PHASE 3 DONE — Merge
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative
git checkout main
git merge upgrade/agent-06-packages --no-edit
git merge style/agent-07-consistency --no-edit


# ============================================================
# PHASE 4A: 📝 DocWriter (Terminal 1)
# Uses: Elements of Style (writing quality)
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-05-docwriter.md completely.

You are AG-05 DocWriter. Use the Elements of Style plugin for high-quality writing.

STEP 1: Setup
git checkout -b docs/agent-05-documentation

STEP 2: Execute documentation tasks:

/superpowers:write-plan

Write comprehensive documentation for CloudShell:

TASK DC-001 [HIGH]: Add /// doc comments to ALL public classes and methods
→ Go through every file in lib/ (160 files)
→ Every public class gets: /// Brief description\n/// \n/// Detailed explanation
→ Every public method gets: /// Description\n/// [param] explanation\n/// Returns: what
→ Use Elements of Style for clear, concise technical writing

TASK DC-002 [MEDIUM]: Inline WHY comments for complex code
→ lib/services/crypto/vault_crypto_service.dart — explain each crypto step
→ lib/services/ssh/ssh_service.dart — explain handshake, auth negotiation
→ lib/services/telnet/telnet_parser.dart — explain state machine
→ lib/services/sftp/sftp_service.dart — explain chunking, resume
→ lib/services/ssh/ppk_parser.dart — explain PuTTY format

TASK DC-003 [HIGH]: Create docs/ARCHITECTURE.md
→ System overview diagram (ASCII art)
→ Layer diagram: UI → Providers → Services → Data
→ State management with Riverpod
→ Security model (zero-knowledge vault)
→ Responsive design system

TASK DC-006 [HIGH]: Update README.md
→ Project description with screenshots
→ Prerequisites (Flutter, Dart versions)
→ Setup: git clone → flutter pub get → flutter run
→ Build per platform: macOS, iOS, Android, Windows, Linux
→ Architecture overview (brief)
→ Contributing guidelines

TASK DC-004 [MEDIUM]: Create docs/RESPONSIVE.md
→ Breakpoints: mobile < 600, tablet 600-1024, desktop > 1024
→ Platform-specific layouts
→ AdaptiveScaffold pattern

TASK DC-005 [MEDIUM]: Create docs/TESTING.md
→ Test strategy and coverage goals
→ How to run: flutter test, golden tests, integration tests
→ Per-platform testing

TASK DC-007 [LOW]: Clean TODO/FIXME
→ grep -rn "TODO\|FIXME" lib/
→ Remove resolved, add GitHub issue numbers to active ones

TASK DC-008 [LOW]: dartdoc
→ Run: dart doc
→ Fix all warnings

/superpowers:execute-plan

After each task: python3 agents/update-progress.py TASK-ID done AG-05
After each task: git add -A && git commit -m "docs(AG-05): TASK-ID — description"

# ─────────────────────────────────────────────


# ============================================================
# PHASE 4B: ⚡ PerfAgent (Terminal 2 — simultaneously)
# Uses: Code Simplifier (find inefficiencies)
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

Read agents/AG-08-perfagent.md completely.

You are AG-08 PerfAgent. Use Code Simplifier to find performance issues.

STEP 1: Setup
git checkout -b perf/agent-08-optimization

STEP 2: First scan for issues:
/code-simplifier

Scan lib/ for performance issues: eager ListViews, missing const, undisposed controllers, heavy rebuilds, deep widget trees.

STEP 3: Fix each issue:

/superpowers:write-plan

Optimize CloudShell performance:

TASK PF-002 [HIGH]: Terminal rendering
→ Read lib/ui/terminal/terminal_screen.dart and lib/services/terminal/
→ Profile: are there unnecessary rebuilds during output?
→ Check xterm widget configuration for performance
→ Ensure output buffering is efficient
→ Document FPS measurement approach

TASK PF-003 [HIGH]: Memory leak audit
→ grep -rn "StreamSubscription" lib/ — verify all have .cancel() in dispose()
→ grep -rn "TextEditingController" lib/ — verify all disposed
→ grep -rn "AnimationController" lib/ — verify all disposed
→ grep -rn "Timer\." lib/ — verify all cancelled
→ Fix every leak found

TASK PF-001 [MEDIUM]: ListView audit
→ grep -rn "ListView(" lib/ui/ — replace with ListView.builder()
→ Check: hosts list, snippets, keys, logs, SFTP files

TASK PF-004 [LOW]: Build size
→ Run: flutter build macos --analyze-size 2>&1 | tail -20
→ Check assets/ for unused files
→ Report current size per platform

TASK PF-005 [LOW]: const constructors
→ Run: dart analyze lib/ 2>&1 | grep prefer_const
→ Fix all findings

/superpowers:execute-plan

After each task: python3 agents/update-progress.py TASK-ID done AG-08
After each task: git add -A && git commit -m "perf(AG-08): TASK-ID — description"

# ─────────────────────────────────────────────


# ============================================================
# PHASE 4 DONE — Merge
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative
git checkout main
git merge docs/agent-05-documentation --no-edit
git merge perf/agent-08-optimization --no-edit


# ============================================================
# PHASE 5: 🏁 Final QA (Terminal 1)
# Uses: Code Review (final check) + Semgrep + Playwright
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative && claude

# Paste this prompt:
# ─────────────────────────────────────────────

You are the Final QA agent. Run comprehensive verification.

STEP 1: Final code review
/code-review
Review the entire lib/ codebase. Report any remaining issues.

STEP 2: Run all checks:

flutter test --coverage
dart analyze lib/
semgrep --config=auto lib/
semgrep --config=p/secrets .
dart doc

STEP 3: Check remaining violations:
grep -rn "catch (_)" lib/ | wc -l
grep -rn "Color(0x" lib/ui/ | wc -l
grep -rn "TODO" lib/ | wc -l
grep -rn "TextStyle(" lib/ui/ | grep -v theme | wc -l

STEP 4: Build all platforms:
flutter build macos
flutter build ios --no-codesign
flutter build apk

STEP 5: Generate report in review/FINAL-QA-REPORT.md:
- Test coverage percentage (target: 80%)
- dart analyze warnings (target: 0)
- Semgrep findings (target: 0 critical/high)
- Build status per platform
- Remaining issues with severity
- PASS / FAIL verdict

STEP 6: Mark all remaining tasks done:
python3 agents/update-progress.py TW-008 done AG-03
(and any other incomplete tasks from the dashboard)

# ─────────────────────────────────────────────


# ============================================================
# ALL DONE — Tag release
# ============================================================
cd /Users/albinmathew/Project/Termius-Alternative
git checkout main
git tag -a v1.2.0 -m "Quality overhaul: 52 tasks, 8 agents, full coverage"
echo "🎉 All 52 tasks complete!"