import 'package:bloc/bloc.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_events.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_states.dart';

class NewPostBloc extends Bloc<NewPostEvents, NewPostStates> {
  NewPostBloc() : super(const NewPostStates()) {
    on<ImageNewPost>((event, emit) => emit(state.copyWith(image: event.image)));
    on<DescriptionNewPost>(
        (event, emit) => emit(state.copyWith(description: event.description)));
    on<EmptyImage>(
      (event, emit) => emit(state.deleteImage(description: event.description)),
    );
  }
}
