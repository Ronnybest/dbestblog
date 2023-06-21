import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_bloc.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_events.dart';
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
}
