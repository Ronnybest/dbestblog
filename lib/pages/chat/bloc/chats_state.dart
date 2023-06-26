import '../../../common/models/chats.dart';

abstract class ChatsState {}

class ChatsInitialState extends ChatsState {}

class ChatsLoadingState extends ChatsState {}

class ChatsLoadedState extends ChatsState {
  final List<ChatsObj> chats;

  ChatsLoadedState({required this.chats});
}

class ChatsErrorState extends ChatsState {
  final String error;

  ChatsErrorState({required this.error});
}
