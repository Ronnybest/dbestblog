part of 'current_chat_bloc.dart';

class CurrentChatState {
  const CurrentChatState({this.another_user, this.message});
  final UserObj? another_user;
  final String? message;

  CurrentChatState copyWith({UserObj? another_user, String? message}) {
    return CurrentChatState(
      another_user: another_user ?? this.another_user,
      message: message ?? this.message,
    );
  }

  CurrentChatState clearMsg() {
    return CurrentChatState(
      another_user: another_user,
      message: null,
    );
  }
}
