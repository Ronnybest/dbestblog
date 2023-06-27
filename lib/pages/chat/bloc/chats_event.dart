import 'package:dbestblog/common/models/user.dart';

abstract class ChatsEvent {
  const ChatsEvent();
}

class LoadUsersInChats extends ChatsEvent {
  final List<UserObj>? users;
  const LoadUsersInChats({this.users});
}
