import 'package:dbestblog/pages/authorization/bloc/authorization_events.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvents, AuthorizationStates> {
  AuthorizationBloc() : super(const AuthorizationStates()) {
    on<EmailEvent>((event, emit) => emit(state.copyWith(email: event.email)));
    on<PasswordEvent>(
        (event, emit) => emit(state.copyWith(password: event.password)));
    on<ResetAuthBloc>((event, emit) => emit(state.reset()));
  }
}
