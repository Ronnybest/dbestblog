import 'package:flutter_bloc/flutter_bloc.dart';

import 'chats_event.dart';
import 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsState()) {
    on<LoadUsersInChats>(
        (event, emit) => emit(state.copyWith(chatUsers: event.users)));
    on<GetChatObjFromServer>(
        (event, emit) => emit(state.copyWith(currentChat: event.currentChat)));
  }
}
