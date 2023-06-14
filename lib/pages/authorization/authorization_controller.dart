import 'package:dbestblog/pages/authorization/bloc/authorization_bloc.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorizationController {
  final BuildContext context;
  AuthorizationController({required this.context});

  Future<void> authorizationEmailPass() async {
    final state = context.read<AuthorizationBloc>().state;
    String email = state.email;
    String password = state.password;

    if (email.isEmpty) {
      buildSnackBar(msg: 'Please, enter email', context: context);
      return;
    }
    if (password.isEmpty) {
      buildSnackBar(msg: 'Please, enter password', context: context);
      return;
    }
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user == null) {
        buildSnackBar(msg: 'Wrong email or password', context: context);
        return;
      }

      var user = credential.user;
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/application", (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        buildSnackBar(msg: e.message.toString(), context: context);
      } else if (e.code == "email-already-in-use") {
        buildSnackBar(msg: e.message.toString(), context: context);
      } else if (e.code == "invalid-email") {
        buildSnackBar(msg: e.message.toString(), context: context);
      }
    }
  }
}
