import 'package:dbestblog/pages/authorization/authorization_controller.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_bloc.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_events.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../registration/widgets/registration_widgets.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  @override
  Widget build(BuildContext context) {
    RegistrationWidgets widgets = RegistrationWidgets(context: context);
    return BlocBuilder<AuthorizationBloc, AuthorizationStates>(
        builder: (context, state) {
      return Container(
        child: Scaffold(
          appBar: widgets.buildAppBar(titleText: 'Authorization'),
          body: Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(children: [
              widgets.buildTextFields(
                  hintText: 'Email',
                  type: 'input',
                  func: (value) => context
                      .read<AuthorizationBloc>()
                      .add(EmailEvent(email: value!))),
              const SizedBox(
                height: 20,
              ),
              widgets.buildTextFields(
                  hintText: 'Password',
                  type: 'pass',
                  func: (value) => context
                      .read<AuthorizationBloc>()
                      .add(PasswordEvent(password: value!))),
              widgets.buildButton(
                  text: 'Authorization', type: 'confirm', func: auth),
              widgets.buildButton(
                  text: 'Registration', type: '', func: gotoReg),
            ]),
          ),
        ),
      );
    });
  }

  void auth() {
    AuthorizationController(context: context).authorizationEmailPass();
  }

  void gotoReg() {
    Navigator.of(context).pushNamed("/registration");
  }
}
