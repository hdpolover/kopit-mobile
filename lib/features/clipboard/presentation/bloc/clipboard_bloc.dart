import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/clipboard_item.dart';
import '../../domain/repositories/clipboard_repository.dart';
import 'clipboard_event.dart';
import 'clipboard_state.dart';

// Internal events
class _ClipboardUpdated extends ClipboardEvent {
  final List<ClipboardItem> items;
  const _ClipboardUpdated(this.items);
  @override
  List<Object> get props => [items];
}

class _ClipboardErrorEvent extends ClipboardEvent {
  final String message;
  const _ClipboardErrorEvent(this.message);
  @override
  List<Object> get props => [message];
}

@injectable
class ClipboardBloc extends Bloc<ClipboardEvent, ClipboardState> {
  final ClipboardRepository _repository;
  StreamSubscription? _clipboardSubscription;

  ClipboardBloc(this._repository) : super(ClipboardLoading()) {
    on<LoadClipboardItems>(_onLoadClipboardItems);
    on<AddClipboardItem>(_onAddClipboardItem);
    on<DeleteClipboardItem>(_onDeleteClipboardItem);
    on<TogglePinItem>(_onTogglePinItem);
    on<SearchClipboardItems>(_onSearchClipboardItems);
    
    // Internal handlers
    on<_ClipboardUpdated>((event, emit) => emit(ClipboardLoaded(event.items)));
    on<_ClipboardErrorEvent>((event, emit) => emit(ClipboardError(event.message)));
  }

  void _onLoadClipboardItems(LoadClipboardItems event, Emitter<ClipboardState> emit) {
    emit(ClipboardLoading());
    _clipboardSubscription?.cancel();
    _clipboardSubscription = _repository.getClipboardItems().listen(
      (items) => add(_ClipboardUpdated(items)),
      onError: (error) => add(_ClipboardErrorEvent(error.toString())),
    );
  }

  void _onAddClipboardItem(AddClipboardItem event, Emitter<ClipboardState> emit) async {
    try {
      await _repository.addClipboardItem(event.content);
    } catch (e) {
      emit(ClipboardError(e.toString()));
    }
  }

  void _onDeleteClipboardItem(DeleteClipboardItem event, Emitter<ClipboardState> emit) async {
    try {
      await _repository.deleteClipboardItem(event.id);
    } catch (e) {
      emit(ClipboardError(e.toString()));
    }
  }

  void _onTogglePinItem(TogglePinItem event, Emitter<ClipboardState> emit) async {
    try {
      await _repository.togglePin(event.id);
    } catch (e) {
      emit(ClipboardError(e.toString()));
    }
  }

  void _onSearchClipboardItems(SearchClipboardItems event, Emitter<ClipboardState> emit) async {
    if (event.query.isEmpty) {
      add(LoadClipboardItems());
      return;
    }
    
    _clipboardSubscription?.cancel();
    emit(ClipboardLoading());
    
    try {
      final results = await _repository.searchClipboardItems(event.query);
      emit(ClipboardLoaded(results));
    } catch (e) {
      emit(ClipboardError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _clipboardSubscription?.cancel();
    return super.close();
  }
}
