import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_bloc.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_events.dart';
import 'package:dbestblog/pages/chat/bloc/chats_bloc.dart';
import 'package:dbestblog/pages/chat/bloc/chats_event.dart';
import 'package:dbestblog/pages/chat/current_chat/bloc/current_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnotherUserProfileController {
  final BuildContext context;
  AnotherUserProfileController({required this.context});
  late UserObj _userObj;
  late List<PostObj> _posts;
  late String _userId;

  init() async {
    _userId = context.read<AnotherUserProfileBloc>().state.userId!;
    _userObj = UserObj.fromMap(await getUserData()!);
    _userObj.id = _userId;
    _posts = await getUserPosts();
    context
        .read<AnotherUserProfileBloc>()
        .add(LoadProfileAndPosts(_userObj, _posts, _userId));
    return;
  }

  Future<Map<String, dynamic>>? getUserData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Users');
    final querrySnapshot =
        await collectionRef.where('id', isEqualTo: _userId).get();
    if (querrySnapshot.docs.isNotEmpty) {
      return querrySnapshot.docs.first.data();
    } else {
      return {};
    }
  }

  Future<List<PostObj>> getUserPosts() async {
    List<PostObj> posts = [];
    final postSnapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .where('author_id', isEqualTo: _userId)
        .orderBy('upload_time', descending: true)
        .get();
    for (final postDoc in postSnapshot.docs) {
      final post = postDoc.data();
      PostObj postObj = PostObj(); // Создаем новый экземпляр на каждой итерации
      postObj.author_id = post['author_id'];
      postObj.image_link = post['image_link'];
      postObj.description = post['description'];
      postObj.author_name = _userObj.name;
      postObj.post_id = post['post_id'];
      postObj.auhtor_avatar = _userObj.avatarLink;
      posts.add(postObj);
    }
    return posts;
  }

  Future<void> createNewChat() async {
    UserObj toUser = context.read<AnotherUserProfileBloc>().state.userObj!;
    UserObj fromUser = Global.storageServices.getUserProfile()!;
    context.read<CurrentChatBloc>().add(LoadAnotherUser(toUser));

    final String fromUserId = fromUser.id!;
    final String toUserId = toUser.id!;

    // Проверяем наличие чата, где from_user_id = fromUserId и to_user_id = toUserId
    final QuerySnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('Chats')
        .where('from_user_id', isEqualTo: fromUserId)
        .where('to_user_id', isEqualTo: toUserId)
        .limit(1)
        .get();

    // Проверяем наличие чата, где from_user_id = toUserId и to_user_id = fromUserId
    final QuerySnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('Chats')
        .where('from_user_id', isEqualTo: toUserId)
        .where('to_user_id', isEqualTo: fromUserId)
        .limit(1)
        .get();

    final List<QueryDocumentSnapshot> documents1 = snapshot1.docs;
    final List<QueryDocumentSnapshot> documents2 = snapshot2.docs;

    final List<QueryDocumentSnapshot> allDocuments = [
      ...documents1,
      ...documents2
    ];

    if (allDocuments.isNotEmpty) {
      print('chat exists');
      if (context.mounted) {
        context.read<ChatsBloc>().add(GetChatObjFromServer(ChatsObj.fromMap(
            allDocuments.first.data() as Map<String, dynamic>)));
        //print(context.read<ChatsBloc>().state.currentChat?.last_msg ?? 'error');
        Navigator.pushNamed(
          context,
          '/current_chat',
        );
      }
    } else {
      ChatsObj chatsObj = ChatsObj(
        from_user_id: fromUser.id,
        to_user_id: toUser.id,
        last_msg: '',
        last_msg_time: Timestamp.now(),
        last_msg_user_id: '',
        chat_id: '',
      );
      final _db = FirebaseFirestore.instance;
      DocumentReference dr =
          await _db.collection('Chats').add(chatsObj.toMap());
      chatsObj.chat_id = dr.id;
      await _db.collection('Chats').doc(dr.id).update({'chat_id': dr.id});

      if (context.mounted) {
        context.read<ChatsBloc>().add(GetChatObjFromServer(chatsObj));
        Navigator.pushNamed(
          context,
          '/current_chat',
        );
      }
    }
  }
}
