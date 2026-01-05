import 'package:equatable/equatable.dart';
import '../../domain/entities/clipboard_item.dart';

abstract class ClipboardState extends Equatable {
  const ClipboardState();
  
  @override
  List<Object> get props => [];
}

class ClipboardLoading extends ClipboardState {}

class ClipboardLoaded extends ClipboardState {
  final List<ClipboardItem> items;

  const ClipboardLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ClipboardError extends ClipboardState {
  final String message;

  const ClipboardError(this.message);

  @override
  List<Object> get props => [message];
}
