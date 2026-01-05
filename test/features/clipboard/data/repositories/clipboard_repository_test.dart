import 'package:kopit/core/database/app_database.dart';
import 'package:kopit/features/clipboard/data/repositories/clipboard_repository_impl.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late ClipboardRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ClipboardRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('should add and retrieve clipboard items', () async {
    await repository.addClipboardItem('Test Content');

    final items = await repository.getClipboardItems().first;
    
    expect(items.length, 1);
    expect(items.first.content, 'Test Content');
    expect(items.first.isPinned, false);
  });

  test('should delete clipboard item', () async {
    await repository.addClipboardItem('To Delete');
    var items = await repository.getClipboardItems().first;
    expect(items.length, 1);
    final id = items.first.id;

    await repository.deleteClipboardItem(id);

    items = await repository.getClipboardItems().first;
    expect(items.isEmpty, true);
  });

  test('should toggle pin status', () async {
    await repository.addClipboardItem('Pin Me');
    var items = await repository.getClipboardItems().first;
    final id = items.first.id;
    expect(items.first.isPinned, false);

    await repository.togglePin(id);

    items = await repository.getClipboardItems().first;
    expect(items.first.isPinned, true);

    await repository.togglePin(id);
    items = await repository.getClipboardItems().first;
    expect(items.first.isPinned, false);
  });

  test('should search clipboard items', () async {
    await repository.addClipboardItem('Apple');
    await repository.addClipboardItem('Banana');
    await repository.addClipboardItem('Pineapple');

    // Note: FTS5 might behave differently in memory or require specific setup.
    // But since we used LIKE as a fallback in the repo implementation, it should work fine.
    
    final results = await repository.searchClipboardItems('Apple');
    expect(results.length, 2); // Apple and Pineapple
    
    final results2 = await repository.searchClipboardItems('Banana');
    expect(results2.length, 1);
  });
}
