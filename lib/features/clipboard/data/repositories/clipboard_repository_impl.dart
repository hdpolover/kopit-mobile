import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/clipboard_item.dart';
import '../../domain/repositories/clipboard_repository.dart';

@LazySingleton(as: ClipboardRepository)
class ClipboardRepositoryImpl implements ClipboardRepository {
  final AppDatabase _db;

  ClipboardRepositoryImpl(this._db);

  @override
  Stream<List<ClipboardItem>> getClipboardItems() {
    return (_db.select(_db.clipboardClips)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((rows) {
      return rows.map((row) => ClipboardItem(
        id: row.id,
        content: row.content,
        createdAt: row.createdAt,
        isPinned: row.isPinned,
        category: row.category,
      )).toList();
    });
  }

  @override
  Future<void> addClipboardItem(String content) async {
    await _db.into(_db.clipboardClips).insert(
      ClipboardClipsCompanion.insert(
        content: content,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> deleteClipboardItem(int id) async {
    await (_db.delete(_db.clipboardClips)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> togglePin(int id) async {
    final item = await (_db.select(_db.clipboardClips)..where((t) => t.id.equals(id))).getSingle();
    await (_db.update(_db.clipboardClips)..where((t) => t.id.equals(id))).write(
      ClipboardClipsCompanion(isPinned: Value(!item.isPinned)),
    );
  }

  @override
  Future<List<ClipboardItem>> searchClipboardItems(String query) async {
    // Using LIKE as fallback for FTS match
    final results = await (_db.select(_db.clipboardSearch)
          ..where((tbl) => tbl.content.like('%$query%')))
        .join([
      innerJoin(_db.clipboardClips,
          _db.clipboardClips.id.equalsExp(const CustomExpression<int>('clipboard_search.rowid')))
    ]).get();

    return results.map((row) {
      final clip = row.readTable(_db.clipboardClips);
      return ClipboardItem(
        id: clip.id,
        content: clip.content,
        createdAt: clip.createdAt,
        isPinned: clip.isPinned,
        category: clip.category,
      );
    }).toList();
  }
}
