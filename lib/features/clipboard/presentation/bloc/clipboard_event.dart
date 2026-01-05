import 'package:equatable/equatable.dart';

abstract class ClipboardEvent extends Equatable {
  const ClipboardEvent();

  @override
  List<Object> get props => [];
}

class LoadClipboardItems extends ClipboardEvent {}

class AddClipboardItem extends ClipboardEvent {
  final String content;

  const AddClipboardItem(this.content);

  @override
  List<Object> get props => [content];
}

class DeleteClipboardItem extends ClipboardEvent {
  final int id;

  const DeleteClipboardItem(this.id);

  @override
  List<Object> get props => [id];
}

class TogglePinItem extends ClipboardEvent {
  final int id;

  const TogglePinItem(this.id);

  @override
  List<Object> get props => [id];
}

class SearchClipboardItems extends ClipboardEvent {
  final String query;

  const SearchClipboardItems(this.query);

  @override
  List<Object> get props => [query];
}
