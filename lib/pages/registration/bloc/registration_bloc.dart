import 'package:bloc/bloc.dart';
import 'package:dbestblog/pages/registration/bloc/registration_events.dart';
import 'package:dbestblog/pages/registration/bloc/registration_states.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStates> {
  RegistrationBloc() : super(const RegistrationStates()) {
    on<UserNameEvent>((event, emit) {
      emit(state.copyWith(name: event.username));
    });
    on<EmailEvent>((event, emit) => emit(state.copyWith(email: event.email)));
    on<PasswordEvent>(
        (event, emit) => emit(state.copyWith(password: event.password)));
    on<RePasswordEvent>(
        (event, emit) => emit(state.copyWith(rePassword: event.rePassword)));
  }
}
