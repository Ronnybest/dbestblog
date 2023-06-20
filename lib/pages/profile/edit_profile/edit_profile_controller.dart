import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/profile/bloc/profile_bloc.dart';
import 'package:dbestblog/pages/profile/bloc/profile_events.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../common/values/constants.dart';

class EditProfileController {
  final BuildContext context;
  final UserObj? userProfile = Global.storageServices.getUserProfile();
  EditProfileController({required this.context});

  Future<void> changeInfo() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    final state = context.read<EditProfileBloc>().state;
    final avatar = state.avatar;
    final nickname = state.nickname;
    final bio = state.bio;
    final userId = userProfile!.id;

    final String avatarUrl;
    if (avatar != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('avatars').child('$userId.jpg');
      final uploadTask = storageRef.putFile(avatar);
      final snapshot = await uploadTask.whenComplete(() {});

      // Получение ссылки на загруженный аватар
      avatarUrl = await snapshot.ref.getDownloadURL();

      // Обновление информации о пользователе в Firestore
      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);
      await userRef.update({
        'avatarLink': avatarUrl,
        'name': nickname,
        'bio': bio,
      });
    } else {
      // Если аватар не был выбран, обновляем только остальные поля
      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);
      await userRef.update({
        'name': nickname,
        'bio': bio,
      });
    }
    UserObj newData = UserObj.fromMap(await getDataById('Users', userId!));
    Global.storageServices
        .setStringToKey(AppConstants().USER_INFO, jsonEncode(newData.toMap()));
    EasyLoading.dismiss();
    context.read<ProfileBloc>().add(UpdateProfile(newData));
  }

  Future<Map<String, dynamic>> getDataById(
      String collectionName, String documentId) async {
    final documentRef =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);
    final documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data()!;
    } else {
      print('Документ не найден');
      return {};
    }
  }
}
