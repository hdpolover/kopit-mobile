import 'package:bloc_test/bloc_test.dart';
import 'package:kopit/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:kopit/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:kopit/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:kopit/features/clipboard/presentation/bloc/clipboard_event.dart';
import 'package:kopit/features/clipboard/presentation/bloc/clipboard_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clipboard_bloc_test.mocks.dart';

@GenerateMocks([ClipboardRepository])
void main() {
  late ClipboardBloc clipboardBloc;
  late MockClipboardRepository mockClipboardRepository;

  setUp(() {
    mockClipboardRepository = MockClipboardRepository();
    clipboardBloc = ClipboardBloc(mockClipboardRepository);
  });

  tearDown(() {
    clipboardBloc.close();
  });

  final tClipboardItem = ClipboardItem(
    id: 1,
    content: 'Test Content',
    createdAt: DateTime.now(),
  );
  final tClipboardList = [tClipboardItem];

  test('initial state should be ClipboardLoading', () {
    expect(clipboardBloc.state, equals(ClipboardLoading()));
  });

  blocTest<ClipboardBloc, ClipboardState>(
    'emits [ClipboardLoading, ClipboardLoaded] when LoadClipboardItems is added and repository returns data',
    build: () {
      when(mockClipboardRepository.getClipboardItems())
          .thenAnswer((_) => Stream.value(tClipboardList));
      return clipboardBloc;
    },
    act: (bloc) => bloc.add(LoadClipboardItems()),
    expect: () => [
      ClipboardLoading(),
      ClipboardLoaded(tClipboardList),
    ],
  );

  blocTest<ClipboardBloc, ClipboardState>(
    'emits [ClipboardError] when LoadClipboardItems is added and repository throws error',
    build: () {
      when(mockClipboardRepository.getClipboardItems())
          .thenAnswer((_) => Stream.error('Error loading clips'));
      return clipboardBloc;
    },
    act: (bloc) => bloc.add(LoadClipboardItems()),
    expect: () => [
      ClipboardLoading(),
      const ClipboardError('Error loading clips'),
    ],
  );

  blocTest<ClipboardBloc, ClipboardState>(
    'calls addClipboardItem on repository when AddClipboardItem is added',
    build: () {
      when(mockClipboardRepository.addClipboardItem(any))
          .thenAnswer((_) async => Future.value());
      return clipboardBloc;
    },
    act: (bloc) => bloc.add(const AddClipboardItem('New Clip')),
    verify: (bloc) {
      verify(mockClipboardRepository.addClipboardItem('New Clip')).called(1);
    },
  );

  blocTest<ClipboardBloc, ClipboardState>(
    'calls deleteClipboardItem on repository when DeleteClipboardItem is added',
    build: () {
      when(mockClipboardRepository.deleteClipboardItem(any))
          .thenAnswer((_) async => Future.value());
      return clipboardBloc;
    },
    act: (bloc) => bloc.add(const DeleteClipboardItem(1)),
    verify: (bloc) {
      verify(mockClipboardRepository.deleteClipboardItem(1)).called(1);
    },
  );

  blocTest<ClipboardBloc, ClipboardState>(
    'emits [ClipboardLoading, ClipboardLoaded] when SearchClipboardItems is added',
    build: () {
      when(mockClipboardRepository.searchClipboardItems(any))
          .thenAnswer((_) async => tClipboardList);
      return clipboardBloc;
    },
    act: (bloc) => bloc.add(const SearchClipboardItems('Test')),
    expect: () => [
      ClipboardLoading(),
      ClipboardLoaded(tClipboardList),
    ],
    verify: (bloc) {
      verify(mockClipboardRepository.searchClipboardItems('Test')).called(1);
    },
  );
}
