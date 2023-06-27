import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:flutter/material.dart';

StreamController<List<ChatsObj>> _chatsController =
    StreamController<List<ChatsObj>>.broadcast();

Stream<List<ChatsObj>> getChatsStream() {
  UserObj currentUser = Global.storageServices.getUserProfile()!;
  FirebaseFirestore.instance
      .collection('Chats')
      .where('to_user_id', isEqualTo: currentUser.id)
      .get()
      .then((querySnapshot1) {
    FirebaseFirestore.instance
        .collection('Chats')
        .where('from_user_id', isEqualTo: currentUser.id)
        .get()
        .then((querySnapshot2) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents1 =
          querySnapshot1.docs;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents2 =
          querySnapshot2.docs;

      List<ChatsObj> allChats = [];
      for (final postDoc in documents1) {
        final chat = postDoc.data();
        ChatsObj chatsObj = ChatsObj.fromMap(chat);
        allChats.add(chatsObj);
      }
      for (final postDoc in documents2) {
        final chat = postDoc.data();
        ChatsObj chatsObj = ChatsObj.fromMap(chat);
        allChats.add(chatsObj);
      }

      _chatsController.sink.add(allChats);
    }).catchError((error) {
      print('Error loading chats: $error');
      _chatsController.sink.addError(error);
    });
  }).catchError((error) {
    print('Error loading chats: $error');
    _chatsController.sink.addError(error);
  });

  return _chatsController.stream;
}

@override
void dispose() {
  _chatsController.close();
}

class ChatsController {
  BuildContext context;
  ChatsController({required this.context});

  // Future<void> init() async {
  //   UserObj currentUser = Global.storageServices.getUserProfile()!;
  //   final querySnapshot1 = await FirebaseFirestore.instance
  //       .collection('Chats')
  //       .where('to_user_id', isEqualTo: currentUser.id)
  //       .get();
  //   final querySnapshot2 = await FirebaseFirestore.instance
  //       .collection('Chats')
  //       .where('from_user_id', isEqualTo: currentUser.id)
  //       .get();

  //   List<QueryDocumentSnapshot<Map<String, dynamic>>> documents1 =
  //       querySnapshot1.docs;
  //   List<QueryDocumentSnapshot<Map<String, dynamic>>> documents2 =
  //       querySnapshot2.docs;

  //   List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocuments = [
  //     ...documents1,
  //     ...documents2
  //   ];

  //   List<ChatsObj> allChats = [];
  //   for (final postDoc in allDocuments) {
  //     final chat = postDoc.data();
  //     ChatsObj chatsObj = ChatsObj.fromMap(chat);
  //     allChats.add(chatsObj); // Создаем новый экземпляр на каждой итерации
  //   }
  //   context.read<ChatsBloc>().add(LoadChats(chats: allChats));
  //   print(allChats[0].from_user_id.toString());
  // }
}
