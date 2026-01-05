import 'package:kopit/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:kopit/features/clipboard/presentation/widgets/clipboard_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ClipboardItemWidget displays content and date', (WidgetTester tester) async {
    final item = ClipboardItem(
      id: 1,
      content: 'Test Content',
      createdAt: DateTime(2023, 1, 1, 12, 0),
      isPinned: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClipboardItemWidget(
            item: item,
            onTap: () {},
            onLongPress: () {},
            onPinToggle: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Content'), findsOneWidget);
    // The date format might vary depending on locale/implementation, 
    // but we know it contains the string representation in the current implementation.
    // "2023-01-01 12:00:00.000" -> split('.')[0] -> "2023-01-01 12:00:00"
    expect(find.textContaining('2023-01-01'), findsOneWidget);
    expect(find.byIcon(Icons.push_pin_outlined), findsOneWidget);
  });

  testWidgets('ClipboardItemWidget shows filled pin icon when pinned', (WidgetTester tester) async {
    final item = ClipboardItem(
      id: 1,
      content: 'Pinned Content',
      createdAt: DateTime.now(),
      isPinned: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClipboardItemWidget(
            item: item,
            onTap: () {},
            onLongPress: () {},
            onPinToggle: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.push_pin), findsOneWidget);
  });

  testWidgets('ClipboardItemWidget callbacks work', (WidgetTester tester) async {
    bool tapped = false;
    bool longPressed = false;
    bool pinToggled = false;

    final item = ClipboardItem(
      id: 1,
      content: 'Callback Test',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClipboardItemWidget(
            item: item,
            onTap: () => tapped = true,
            onLongPress: () => longPressed = true,
            onPinToggle: () => pinToggled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ListTile));
    expect(tapped, true);

    await tester.longPress(find.byType(ListTile));
    expect(longPressed, true);

    await tester.tap(find.byType(IconButton));
    expect(pinToggled, true);
  });
}
