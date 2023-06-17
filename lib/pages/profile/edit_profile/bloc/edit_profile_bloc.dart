import 'package:bloc/bloc.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_events.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_states.dart';

class EditProfileBloc extends Bloc<EditProfileEvents, EditProfileStates> {
  EditProfileBloc() : super(const EditProfileStates()) {
    on<ChangeAvatar>(
      (event, emit) => emit(
        state.copyWith(avatar: event.avatar),
      ),
    );
    on<ChangeNickname>(
      (event, emit) => emit(
        state.copyWith(nickname: event.nickname),
      ),
    );
    on<ChangeBio>(
      (event, emit) => emit(
        state.copyWith(bio: event.bio),
      ),
    );
    on<ResetBloc>(
      (event, emit) => emit(
        state.reset(bio: null, nickname: null, avatar: null),
      ),
    );
  }
}
