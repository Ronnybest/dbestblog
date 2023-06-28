import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/common/models/user.dart';

class ChatsState {
  final List<UserObj>? chatUsers;
  final ChatsObj? currentChat;
  ChatsState({this.chatUsers, this.currentChat});

  ChatsState copyWith({List<UserObj>? chatUsers, ChatsObj? currentChat}) {
    return ChatsState(
      chatUsers: chatUsers ?? this.chatUsers,
      currentChat: currentChat ?? this.currentChat,
    );
  }
}
