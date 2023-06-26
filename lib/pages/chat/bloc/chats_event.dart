part of 'chats_bloc.dart';

abstract class ChatsEvent {
  const ChatsEvent();
}

class LoadChats extends ChatsEvent {
  final List<ChatsObj>? chats;
  const LoadChats({this.chats});
}
