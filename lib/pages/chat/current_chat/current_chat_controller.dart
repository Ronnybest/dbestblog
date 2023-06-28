import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/common/models/message.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/chat/bloc/chats_bloc.dart';
import 'package:dbestblog/pages/chat/current_chat/bloc/current_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentChatController {
  final BuildContext context;
  const CurrentChatController({required this.context});
  Future<void> fetchChats(StreamController<List<MessageObj>> _chatsController,
      ScrollController scrollController) async {
    ChatsObj currentChat = context.read<ChatsBloc>().state.currentChat!;
    print(currentChat.chat_id);
    FirebaseFirestore.instance
        .collection('Messages')
        .where('chat_id', isEqualTo: currentChat.chat_id)
        .orderBy('upload_time', descending: false)
        .snapshots()
        .listen((snapshot1) async {
      List<QueryDocumentSnapshot<Object?>> documents = snapshot1.docs;

      List<MessageObj> allMessages = [];
      for (final msgDoc in documents) {
        final msg = msgDoc.data() as Map<String, dynamic>;
        MessageObj msgObj = MessageObj.fromMap(msg);
        allMessages.add(msgObj);
      }
      _chatsController.sink.add(allMessages);
      await Future.delayed(Duration(milliseconds: 100));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      //print('stream load successfully');
    });
  }

  Future<void> sendMsg() async {
    UserObj currentUser = Global.storageServices.getUserProfile()!;
    ChatsObj currentChat = context.read<ChatsBloc>().state.currentChat!;
    MessageObj msg = MessageObj(
      upload_time: Timestamp.now(),
      chat_id: currentChat.chat_id,
      message: context.read<CurrentChatBloc>().state.message,
      message_from_id: currentUser.id,
      message_id: '',
    );
    final _db = FirebaseFirestore.instance;
    DocumentReference _dr = await _db.collection('Messages').add(msg.toMap());
    await _db.collection('Messages').doc(_dr.id).update({'message_id': _dr.id});
    await _db.collection('Chats').doc(currentChat.chat_id).update({
      'last_msg': msg.message,
      'last_msg_time': Timestamp.now(),
      'last_msg_user_id': msg.message_from_id
    });
  }
}
