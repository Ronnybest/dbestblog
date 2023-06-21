import 'package:dbestblog/pages/home/view_post/bloc/view_post_events.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewPostBloc extends Bloc<ViewPostEvents, ViewPostStates> {
  ViewPostBloc() : super(const ViewPostStates()) {
    on<LoadComments>((event, emit) => emit(state.copyWith(
        users: event.users,
        commentsObj: event.commentsObj,
        currentPost: event.postObj)));
    on<ResetComments>((event, emit) => emit(state.reset()));
    on<WriteMsg>((event, emit) => emit(state.copyWith(msg: event.msg)));
  }
}
