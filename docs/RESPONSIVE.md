# Responsive Layout

CloudShell uses a three-tier responsive layout system that adapts between phone, tablet, and desktop form factors. All breakpoint values live in `AppConstants` (`lib/core/constants/app_constants.dart`), and the layout logic is centralized in `AdaptiveScaffold` (`lib/ui/shared/adaptive_scaffold.dart`).

## Breakpoints

| Tier | Width | Constant | Navigation |
|------|-------|----------|------------|
| Phone | < 600px | `AppConstants.phoneBreakpoint` | Bottom nav bar |
| Tablet / Compact | 600 -- 900px | Between `phoneBreakpoint` and `compactSidebarBreakpoint` | Icon-only sidebar (60px) |
| Desktop | >= 900px | `AppConstants.compactSidebarBreakpoint` | Full sidebar (256px) or user-collapsed (60px) |

Additional reference values: `desktopBreakpoint` (768px) and `wideDesktopBreakpoint` (1200px) exist in `AppConstants` for finer-grained layout decisions within individual screens.

## Layout Tiers

**Full sidebar (>= 900px)** -- The sidebar shows icons and text labels for Hosts, Keys, Snippets, Port Forwarding, and Settings. Users can manually collapse it to icon-only mode (60px) via the toggle at the bottom. A Chrome-style workspace tab bar sits above the content area.

**Compact sidebar (600 -- 900px)** -- The sidebar is forced into icon-only collapsed mode (`forceCollapsed: true`). This covers iPad Split View at 50/50, narrow desktop windows, and similar constrained widths. The workspace tab bar remains visible.

**Bottom navigation (< 600px)** -- A standard `BottomNavigationBar` replaces the sidebar entirely. Only four destinations are shown (Hosts, Keys, Snippets, Settings) to keep the bar compact. Port Forwarding and SFTP are accessed from within their parent screens.

## AdaptiveScaffold

`AdaptiveScaffold` is a `ConsumerWidget` that wraps GoRouter's `ShellRoute` child. On every build it reads `MediaQuery.sizeOf(context).width` and selects the appropriate layout:

```dart
if (width >= AppConstants.compactSidebarBreakpoint) {
  // Full desktop layout
  _DesktopLayout(forceCollapsed: false, ...)
} else if (width >= AppConstants.phoneBreakpoint) {
  // Compact desktop layout -- sidebar forced to icon-only
  _DesktopLayout(forceCollapsed: true, ...)
} else {
  // Mobile layout -- bottom navigation bar
  _MobileLayout(...)
}
```

The `forceCollapsed` parameter on `_DesktopLayout` overrides the user's sidebar preference, ensuring that tablet-width windows always get the narrow 60px sidebar regardless of the saved collapsed/expanded state.

Global keyboard shortcuts (Cmd+K for command palette, Cmd+N for new host, Cmd+Shift+N for quick connect, Cmd+, for settings) are registered at this level via `CallbackShortcuts`, so they work on every screen.

## Platform Considerations

**iPad Split View** -- At 50/50 split (~507px per app on 11" iPad), the app lands in the compact sidebar tier. At 2/3 split (~678px), it stays in compact sidebar. Full screen (1024px+) gets the full sidebar.

**iPad Slide Over** -- The narrow Slide Over panel is typically under 400px, triggering the phone/bottom-nav layout automatically.

**Desktop window resizing** -- The layout switches in real time as the user resizes the window. No restart or navigation reset is needed; `MediaQuery` triggers a rebuild and `AdaptiveScaffold` re-evaluates the tier.

**Touch targets** -- All interactive elements respect `AppConstants.minTouchTarget` (44px), matching Apple HIG guidelines across all tiers.

## Implementation Pattern

Individual screens do not need to handle navigation chrome. They receive their content area from GoRouter and render within whatever layout `AdaptiveScaffold` provides. Screens that need width-aware internal layout can query `MediaQuery` directly:

```dart
@override
Widget build(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final isWide = width >= AppConstants.compactSidebarBreakpoint;

  return isWide
      ? Row(children: [listPanel, Expanded(child: detailPanel)])
      : listPanel; // detail pushed as separate route on narrow screens
}
```

Sidebar width constants (`sidebarWidth: 256.0`, `sidebarCollapsedWidth: 60.0`) are defined in `AppConstants` and used consistently by the sidebar builder.
