import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_events.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnotherUserProfileBloc
    extends Bloc<AnotherUserProfileEvents, AnotherUserProfileStates> {
  AnotherUserProfileBloc() : super(const AnotherUserProfileStates()) {
    on<LoadProfileAndPosts>((event, emit) => emit(state.copyWith(
        user: event.user, posts: event.posts, userId: event.userId)));
    on<ResetAnotherProfile>((event, emit) => emit(state.reset()));
  }
}
