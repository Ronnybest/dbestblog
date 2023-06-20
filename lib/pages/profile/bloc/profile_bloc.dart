import 'package:bloc/bloc.dart';
import 'package:dbestblog/pages/profile/bloc/profile_events.dart';
import 'package:dbestblog/pages/profile/bloc/profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileStates> {
  ProfileBloc() : super(const ProfileStates()) {
    on<UpdateProfile>(
        (event, emit) => emit(state.copyWith(newObj: event.userObj)));
    on<ResetProfile>((event, emit) => emit(state.reset(userObj: null)));

    on<GetUsersPosts>(
        (event, emit) => emit(state.getUserPost(posts: event.posts)));
  }
}
