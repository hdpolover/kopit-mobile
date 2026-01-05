// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:kopit/app/app.dart';
import 'package:kopit/core/di/injection.dart';
import 'package:kopit/core/utils/clipboard_watcher_service.dart';
import 'package:kopit/core/utils/share_intent_handler.dart';
import 'package:kopit/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:kopit/features/clipboard/presentation/bloc/clipboard_event.dart';
import 'package:kopit/features/clipboard/presentation/bloc/clipboard_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([
  ClipboardBloc,
  ShareIntentHandler,
  ClipboardWatcherService,
])
void main() {
  late MockClipboardBloc mockClipboardBloc;
  late MockShareIntentHandler mockShareIntentHandler;
  late MockClipboardWatcherService mockClipboardWatcherService;

  setUp(() {
    mockClipboardBloc = MockClipboardBloc();
    mockShareIntentHandler = MockShareIntentHandler();
    mockClipboardWatcherService = MockClipboardWatcherService();

    // Setup GetIt
    final getIt = GetIt.instance;
    getIt.reset();
    getIt.registerSingleton<ClipboardBloc>(mockClipboardBloc);
    getIt.registerSingleton<ShareIntentHandler>(mockShareIntentHandler);
    getIt.registerSingleton<ClipboardWatcherService>(mockClipboardWatcherService);

    // Stub methods
    when(mockClipboardBloc.stream).thenAnswer((_) => Stream.value(ClipboardLoading()));
    when(mockClipboardBloc.state).thenReturn(ClipboardLoading());
    when(mockClipboardBloc.close()).thenAnswer((_) async {});
    when(mockClipboardBloc.add(any)).thenReturn(null);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ClipboardManagerApp());

    // Verify that the app title is present (AppBar)
    expect(find.text('Clipboard Manager'), findsOneWidget);
  });
}
