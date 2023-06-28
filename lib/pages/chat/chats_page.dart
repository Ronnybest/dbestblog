import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/pages/chat/bloc/chats_bloc.dart';
import 'package:dbestblog/pages/chat/bloc/chats_event.dart';
import 'package:dbestblog/pages/chat/bloc/chats_state.dart';
import 'package:dbestblog/pages/chat/current_chat/bloc/current_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';

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
  final UserObj myProfile = Global.storageServices.getUserProfile()!;
  Stream<List<ChatsObj>> get chatsStream => _chatsController.stream;

  @override
  void initState() {
    super.initState();
    // _chatsController.init();
    fetchChats();
  }

  @override
  void dispose() {
    _chatsController.close();
    super.dispose();
  }

  Future<void> fetchChats() async {
    //UserObj myProfile = Global.storageServices.getUserProfile()!;
    FirebaseFirestore.instance
        .collection('Chats')
        .where('to_user_id', isEqualTo: myProfile.id)
        .snapshots()
        .listen((snapshot1) async {
      FirebaseFirestore.instance
          .collection('Chats')
          .where('from_user_id', isEqualTo: myProfile.id)
          .snapshots()
          .listen((snapshot2) async {
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
        allChats.sort((a, b) => b.last_msg_time!.compareTo(a.last_msg_time!));

        _chatsController.sink.add(allChats);
        List<UserObj> allChatUsers = [];
        for (final chat in allChats) {
          UserObj _userObj;
          if (chat.from_user_id != myProfile.id) {
            _userObj = UserObj.fromMap(await getUserData(chat.from_user_id)!);
            allChatUsers.add(_userObj);
          }
          if (chat.to_user_id != myProfile.id) {
            _userObj = UserObj.fromMap(await getUserData(chat.to_user_id)!);
            allChatUsers.add(_userObj);
          }
        }
        if (context.mounted) {
          context.read<ChatsBloc>().add(LoadUsersInChats(users: allChatUsers));
        }
      });
    });
  }

  Future<Map<String, dynamic>>? getUserData(String? _userId) async {
    final collectionRef = FirebaseFirestore.instance.collection('Users');
    final querrySnapshot =
        await collectionRef.where('id', isEqualTo: _userId).get();
    if (querrySnapshot.docs.isNotEmpty) {
      return querrySnapshot.docs.first.data();
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final _widgets = RegistrationWidgets(context: context);
    return StreamBuilder<List<ChatsObj>>(
        stream: chatsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('snapshot has data');
            List<ChatsObj> chats = snapshot.data!;
            return BlocBuilder<ChatsBloc, ChatsState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: _widgets.buildAppBar(titleText: 'Chats'),
                  body: SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            if (state.chatUsers != null &&
                                index < state.chatUsers!.length) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<ChatsBloc>()
                                      .add(GetChatObjFromServer(chats[index]));
                                  context.read<CurrentChatBloc>().add(
                                      LoadAnotherUser(state.chatUsers![index]));
                                  Navigator.pushNamed(context, '/current_chat');
                                },
                                child: Container(
                                  child: buildChatItem(
                                    chats[index],
                                    state.chatUsers![index],
                                  ),
                                ),
                              );
                            } else {
                              // Ожидание загрузки данных chatUsers
                              return LinearProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            // Ожидание загрузки данных
            return CircularProgressIndicator();
          }
        });
  }

  Widget buildChatItem(ChatsObj? chat, UserObj? user) {
    if (chat != null && user != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30.r,
                foregroundImage: CachedNetworkImageProvider(user.avatarLink!),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(9.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 260.w,
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user.name ?? 'no name',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 260.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200.w,
                          //height: 100,
                          child: Text(
                            chat.last_msg_user_id == myProfile.id
                                ? 'You: ${chat.last_msg}'
                                : chat.last_msg ?? "no last msg",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp),
                          ),
                        ),
                        Text(
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.normal,
                              fontSize: 14.sp),
                          DateFormat('HH:mm').format(
                            chat.last_msg_time!.toDate(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return LinearProgressIndicator();
    }
  }
}
