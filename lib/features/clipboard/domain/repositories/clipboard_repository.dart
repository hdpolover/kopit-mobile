import '../entities/clipboard_item.dart';

abstract class ClipboardRepository {
  Stream<List<ClipboardItem>> getClipboardItems();
  Future<void> addClipboardItem(String content);
  Future<void> deleteClipboardItem(int id);
  Future<void> togglePin(int id);
  Future<List<ClipboardItem>> searchClipboardItems(String query);
}
