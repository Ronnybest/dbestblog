import 'package:bloc/bloc.dart';

import '../../../../common/models/user.dart';

part 'current_chat_event.dart';
part 'current_chat_state.dart';

class CurrentChatBloc extends Bloc<CurrentChatEvent, CurrentChatState> {
  CurrentChatBloc() : super(const CurrentChatState()) {
    on<WriteMessage>(
        (event, emit) => emit(state.copyWith(message: event.message)));
    on<LoadAnotherUser>((event, emit) =>
        emit(state.copyWith(another_user: event.another_user)));
    on<ClearMsg>((event, emit) => emit(state.clearMsg()));
  }
}
