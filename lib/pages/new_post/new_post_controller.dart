import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/application/bloc/application_events.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_bloc.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_events.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/bloc/application_bloc.dart';

class NewPostController {
  final BuildContext context;
  final Map<String, dynamic> post = {};
  NewPostController({required this.context});

  Future<void> uploadPost() async {
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
      await _db.collection('Posts').add(postObj.toMap());
      buildSnackBar(msg: 'Post has been added successfully', context: context);
      context.read<AppBlocs>().add(const TriggerAppEvent(0));
      // print(dr.id.toString());
      // print('Фото успешно загружено и ссылка сохранена в Firestore.');
    } catch (error) {
      print('Ошибка при загрузке фото: $error');
    }
  }

  Future<void> selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        File tempFile = File(file.path!);
        context.read<NewPostBloc>().add(ImageNewPost(tempFile));
      } else {}
    } catch (error) {
      print('Ошибка при выборе файла: $error');
    }
  }
}
