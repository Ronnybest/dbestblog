part of 'current_chat_bloc.dart';

abstract class CurrentChatEvent {
  const CurrentChatEvent();
}

class WriteMessage extends CurrentChatEvent {
  const WriteMessage(this.message);
  final String? message;
}

class LoadAnotherUser extends CurrentChatEvent {
  const LoadAnotherUser(this.another_user);
  final UserObj another_user;
}
