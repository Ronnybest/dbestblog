import 'package:bloc/bloc.dart';

import 'application_events.dart';
import 'application_states.dart';

class AppBlocs extends Bloc<AppEvents, AppStates> {
  AppBlocs() : super(const AppStates()) {
    on<TriggerAppEvent>((event, emit) {
      emit(AppStates(index: event.index));
    });
  }
}
