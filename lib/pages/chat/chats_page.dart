import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/pages/chat/bloc/chats_bloc.dart';
import 'package:dbestblog/pages/chat/bloc/chats_state.dart';
import 'package:dbestblog/pages/chat/chats_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/models/user.dart';
import '../../global.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({super.key});

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  StreamController<List<ChatsObj>> _chatsController =
      StreamController<List<ChatsObj>>.broadcast();

  Stream<List<ChatsObj>> get chatsStream => _chatsController.stream;

  late ChatsController _chatsControllerNS;
  @override
  void initState() {
    super.initState();
    _chatsControllerNS = ChatsController(context: context);
    // _chatsController.init();
    fetchChats();
  }

  @override
  void dispose() {
    _chatsController.close();
    super.dispose();
  }

  void fetchChats() {
    UserObj currentUser = Global.storageServices.getUserProfile()!;
    FirebaseFirestore.instance
        .collection('Chats')
        .where('to_user_id', isEqualTo: currentUser.id)
        .snapshots()
        .listen((snapshot1) async {
      FirebaseFirestore.instance
          .collection('Chats')
          .where('from_user_id', isEqualTo: currentUser.id)
          .snapshots()
          .listen((snapshot2) {
        List<QueryDocumentSnapshot<Object?>> documents1 = snapshot1.docs;
        List<QueryDocumentSnapshot<Object?>> documents2 = snapshot2.docs;

        List<ChatsObj> allChats = [];
        for (final postDoc in documents1) {
          final chat = postDoc.data() as Map<String, dynamic>;
          ChatsObj chatsObj = ChatsObj.fromMap(chat);
          allChats.add(chatsObj);
        }
        for (final postDoc in documents2) {
          final chat = postDoc.data() as Map<String, dynamic>;
          ChatsObj chatsObj = ChatsObj.fromMap(chat);
          allChats.add(chatsObj);
        }

        _chatsController.sink.add(allChats);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatsObj>>(
        stream: chatsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('snapshot has data');
            List<ChatsObj> chats = snapshot.data!;
            return Scaffold(
              body: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => print(chats.length),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: buildChatItem(
                            chats[index],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Ожидание загрузки данных
            return CircularProgressIndicator();
          }
        });
  }

  Widget buildChatItem(ChatsObj? chat) {
    return chat != null
        ? Container(
            height: 200,
            color: Colors.red,
            child: Text(chat.last_msg ?? ''),
          )
        : Container(
            color: Colors.blue,
          );
  }
}
