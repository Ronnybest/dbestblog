import 'package:bloc/bloc.dart';

import '../../../common/models/chats.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsStates> {
  ChatsBloc() : super(const ChatsStates()) {
    on<LoadChats>((event, emit) {
      emit(state.copyWith(chats: event.chats));
    });
  }
}
