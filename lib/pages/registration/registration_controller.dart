// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/common/values/constants.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/registration/bloc/registration_bloc.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationController {
  final BuildContext context;
  const RegistrationController(this.context);

  Future<void> registerWithEmail() async {
    final state = context.read<RegistrationBloc>().state;
    String? username = state.name;
    String? email = state.email;
    String? password = state.password;
    String? repassword = state.rePassword;

    if (username.isEmpty) {
      buildSnackBar(msg: "Username cannot be empty", context: context);
      return;
    }
    if (email.isEmpty) {
      buildSnackBar(msg: "Email cannot be empty", context: context);
      return;
    }
    if (password.isEmpty) {
      buildSnackBar(msg: "Password cannot be empty", context: context);
      return;
    }
    if (password != repassword) {
      buildSnackBar(
          msg: "Your password confirmation is wrong", context: context);
      return;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user?.sendEmailVerification();
        //String photoUrl = "uploads/default.png";
        await credential.user?.updateDisplayName(username);
        //print("photo url is $photoUrl");
        //await credential.user?.updatePhotoURL(photoUrl);
        UserObj userObj = UserObj(
            name: username,
            email: credential.user!.email,
            avatarLink: await getAvatarLink(),
            bio: 'Simple bio');
        final _db = FirebaseFirestore.instance;
        await _db.collection('Users').add(userObj.toMap());

        Global.storageServices.setStringToKey(
            AppConstants().USER_INFO, jsonEncode(userObj.toMap()));
        // print(
        //     Global.storageServices.getStringFromKey(AppConstants().USER_INFO));
        buildSnackBar(
            msg:
                "Verify your account by link in message  which sent to your email",
            context: context);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/application', (route) => false);
      }
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

  Future<String> getAvatarLink() async {
    final storageRef = FirebaseStorage.instance.ref().child('avatar.jpg');
    final downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  }

  Future<String> assetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final file = File.fromRawPath(byteData.buffer.asUint8List());
    return uploadPhotoToFirebaseStorage(file);
  }

  Future<String> uploadPhotoToFirebaseStorage(File imageFile) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imageFile.path);
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() => null);
    print(await storageTaskSnapshot.ref.getDownloadURL());
    return await storageTaskSnapshot.ref.getDownloadURL();
  }
}
