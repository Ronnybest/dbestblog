import 'package:dbestblog/common/models/user.dart';

class ChatsState {
  final List<UserObj>? chatUsers;
  ChatsState({this.chatUsers});

  ChatsState copyWith({List<UserObj>? chatUsers}) {
    return ChatsState(
      chatUsers: chatUsers ?? this.chatUsers,
    );
  }
}
