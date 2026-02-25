/// Data Access Object for workspace persistence.
///
/// Provides CRUD operations for saved workspaces, including
/// active workspace management and layout storage.
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/workspaces_table.dart';

part 'workspace_dao.g.dart';

/// DAO for workspace layout persistence.
@DriftAccessor(tables: [Workspaces])
class WorkspaceDao extends DatabaseAccessor<AppDatabase>
    with _$WorkspaceDaoMixin {
  WorkspaceDao(super.db);

  /// Gets the currently active workspace, or null if none.
  Future<Workspace?> getActiveWorkspace() {
    return (select(workspaces)..where((w) => w.isActive.equals(true)))
        .getSingleOrNull();
  }

  /// Watches all saved workspaces ordered by last updated.
  Stream<List<Workspace>> watchAllWorkspaces() {
    return (select(workspaces)
          ..orderBy([(w) => OrderingTerm.desc(w.updatedAt)]))
        .watch();
  }

  /// Saves (upserts) a workspace.
  Future<void> saveWorkspace(WorkspacesCompanion workspace) {
    return into(workspaces).insertOnConflictUpdate(workspace);
  }

  /// Sets a workspace as the active one (deactivates all others).
  Future<void> setActiveWorkspace(String id) async {
    await transaction(() async {
      // Deactivate all
      await (update(workspaces))
          .write(const WorkspacesCompanion(isActive: Value(false)));
      // Activate the specified one
      await (update(workspaces)..where((w) => w.id.equals(id)))
          .write(const WorkspacesCompanion(isActive: Value(true)));
    });
  }

  /// Deletes a workspace by ID.
  Future<int> deleteWorkspace(String id) {
    return (delete(workspaces)..where((w) => w.id.equals(id))).go();
  }

  /// Renames a workspace.
  Future<void> renameWorkspace(String id, String newName) {
    return (update(workspaces)..where((w) => w.id.equals(id))).write(
      WorkspacesCompanion(
        name: Value(newName),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
