import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_bloc.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../common/values/constants.dart';
import '../../global.dart';

class AuthorizationController {
  final BuildContext context;
  AuthorizationController({required this.context});

  Future<void> authorizationEmailPass() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
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
      var userData = await getUserData(user!);
      Global.storageServices
          .setStringToKey(AppConstants().USER_INFO, jsonEncode(userData));
      EasyLoading.dismiss();
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/application", (route) => false);
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == "weak-password") {
        buildSnackBar(msg: e.message.toString(), context: context);
      } else if (e.code == "email-already-in-use") {
        buildSnackBar(msg: e.message.toString(), context: context);
      } else if (e.code == "invalid-email") {
        buildSnackBar(msg: e.message.toString(), context: context);
      }
      buildSnackBar(msg: e.message.toString(), context: context);
    }
  }

  Future<Map<String, dynamic>> getUserData(User user) async {
    final collectionRef = FirebaseFirestore.instance.collection('Users');
    final querrySnapshot =
        await collectionRef.where('email', isEqualTo: user.email).get();
    if (querrySnapshot.docs.isNotEmpty) {
      return querrySnapshot.docs.first.data();
    } else {
      return {};
    }
  }
}
