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
    if (!_chatsController.isClosed) {
      //print('stream dont close 1');
      UserObj myProfile = Global.storageServices.getUserProfile()!;
      ChatsObj currentChat = context.read<ChatsBloc>().state.currentChat!;
      //print(currentChat.chat_id);
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
        if (!_chatsController.isClosed) {
          //print('stream dont close 2');
          _chatsController.sink.add(allMessages);
          //await Future.delayed(const Duration(milliseconds: 200));
          Timer(const Duration(milliseconds: 200), () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
          FirebaseFirestore.instance
              .collection('Messages')
              .where('chat_id', isEqualTo: currentChat.chat_id)
              .where('message_from_id', isNotEqualTo: myProfile.id)
              .get()
              .then((snapshot) async {
            for (var doc in snapshot.docs) {
              doc.reference.update({'is_read': true});
            }
          });
        }
        //if (_chatsController.isClosed == true) print('stream close 2');
        //print('stream load successfully');
      });
      final _db = FirebaseFirestore.instance;
      DocumentSnapshot chatSnapshot =
          await _db.collection('Chats').doc(currentChat.chat_id).get();
      String lastMsgId = chatSnapshot['last_msg_user_id'];
      if (lastMsgId != myProfile.id) {
        print('Я ЗАШЕЛ СЮДА Я ЕБАУНТЫЙ');
        await _db.collection('Chats').doc(currentChat.chat_id).update({
          'chat_status': true,
        });
      }
    }

    //if (_chatsController.isClosed == true) print('stream close 1');
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
      is_read: false,
    );
    final _db = FirebaseFirestore.instance;
    DocumentReference _dr = await _db.collection('Messages').add(msg.toMap());
    await _db.collection('Messages').doc(_dr.id).update({'message_id': _dr.id});
    await _db.collection('Chats').doc(currentChat.chat_id).update(
      {
        'last_msg': msg.message,
        'last_msg_time': Timestamp.now(),
        'last_msg_user_id': msg.message_from_id,
        'last_msg_id': _dr.id,
        'chat_status': msg.is_read,
      },
    );
    if (context.mounted) {
      context.read<CurrentChatBloc>().add(const WriteMessage(null));
    }
  }
}
