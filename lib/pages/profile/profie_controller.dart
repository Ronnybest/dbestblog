import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/profile/bloc/profile_bloc.dart';
import 'package:dbestblog/pages/profile/bloc/profile_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/models/post.dart';

class ProfileController {
  ProfileController({required this.context});
  final BuildContext context;

  UserObj init() {
    UserObj userObj = UserObj();
    final state = context.read<ProfileBloc>().state;
    if (state.userObj != null) {
      userObj.id = state.userObj!.id;
      userObj.name = state.userObj!.name;
      userObj.email = state.userObj!.email;
      userObj.avatarLink = state.userObj!.avatarLink;
      userObj.bio = state.userObj!.bio;
    } else {
      userObj = Global.storageServices.getUserProfile()!;
    }
    return userObj;
  }

  Future<void> getUserPosts(String userId) async {
    List<PostObj> posts = [];
    final postSnapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .where('author_id', isEqualTo: userId)
        .orderBy('upload_time', descending: true)
        .get();
    for (final postDoc in postSnapshot.docs) {
      final post = postDoc.data();
      PostObj postObj = PostObj(); // Создаем новый экземпляр на каждой итерации
      postObj.author_id = post['author_id'];
      postObj.image_link = post['image_link'];
      postObj.description = post['description'];
      postObj.author_name = post['author_name'];
      posts.add(postObj);
    }
    context.read<ProfileBloc>().add(GetUsersPosts(posts));
  }
}
