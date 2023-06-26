part of 'chats_bloc.dart';

class ChatsStates {
  final List<ChatsObj>? chats;
  const ChatsStates({this.chats});

  ChatsStates copyWith({List<ChatsObj>? chats}) {
    return ChatsStates(
      chats: chats ?? this.chats,
    );
  }
}
