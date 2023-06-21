// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/application/bloc/application_events.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_bloc.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_events.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../application/bloc/application_bloc.dart';

class NewPostController {
  final BuildContext context;
  final Map<String, dynamic> post = {};
  NewPostController({required this.context});

  Future<void> uploadPost() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    final UserObj = Global.storageServices.getUserProfile();
    PostObj postObj = PostObj();
    String downloadUrl = '';
    final state = context.read<NewPostBloc>().state;
    try {
      if (state.image != null) {
        // Создание ссылки на Firebase Storage без использования папок
        Reference storageRef =
            FirebaseStorage.instance.ref('${DateTime.now()}.jpg');

        // Загрузка файла в Firebase Storage
        UploadTask uploadTask = storageRef.putFile(state.image!);
        TaskSnapshot storageSnapshot = await uploadTask;

        // Получение ссылки на загруженный файл
        downloadUrl = await storageSnapshot.ref.getDownloadURL();
      } else {}
      postObj.image_link = downloadUrl;
      postObj.description = state.description;
      postObj.author_id = UserObj!.id;
      postObj.upload_time = Timestamp.now();
      final _db = FirebaseFirestore.instance;
      DocumentReference _dr =
          await _db.collection('Posts').add(postObj.toMap());
      await _db.collection('Posts').doc(_dr.id).update({'post_id': _dr.id});
      EasyLoading.dismiss();
      buildSnackBar(msg: 'Post has been added successfully', context: context);
      context.read<NewPostBloc>().add(Reset());
      context.read<AppBlocs>().add(const TriggerAppEvent(0));
      // print(dr.id.toString());
      // print('Фото успешно загружено и ссылка сохранена в Firestore.');
    } catch (error) {
      EasyLoading.dismiss();
      print('Ошибка при загрузке фото: $error');
    }
  }

  Future<void> selectImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? result =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (result != null) {
        File tempFile = File(result.path);
        context.read<NewPostBloc>().add(ImageNewPost(tempFile));
      } else {}
    } catch (error) {
      print('Ошибка при выборе файла: $error');
    }
  }
}
