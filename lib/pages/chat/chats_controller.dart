import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/chat/bloc/chats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsController {
  BuildContext context;
  ChatsController({required this.context});

  Future<void> init() async {
    UserObj currentUser = Global.storageServices.getUserProfile()!;
    final querySnapshot1 = await FirebaseFirestore.instance
        .collection('Chats')
        .where('to_user_id', isEqualTo: currentUser.id)
        .get();
    final querySnapshot2 = await FirebaseFirestore.instance
        .collection('Chats')
        .where('from_user_id', isEqualTo: currentUser.id)
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents1 =
        querySnapshot1.docs;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents2 =
        querySnapshot2.docs;

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocuments = [
      ...documents1,
      ...documents2
    ];

    List<ChatsObj> allChats = [];
    for (final postDoc in allDocuments) {
      final chat = postDoc.data();
      ChatsObj chatsObj = ChatsObj.fromMap(chat);
      allChats.add(chatsObj); // Создаем новый экземпляр на каждой итерации
    }
    context.read<ChatsBloc>().add(LoadChats(chats: allChats));
    print(allChats[0].from_user_id.toString());
  }
}
