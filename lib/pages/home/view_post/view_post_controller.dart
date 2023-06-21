// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/comments.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_bloc.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ViewPostController {
  final BuildContext context;
  ViewPostController({required this.context});

  Future<void> init(String post_id) async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    List<CommentsObj> comments = [];
    List<UserObj> users = [];
    final postSnapshot = await FirebaseFirestore.instance
        .collection('Comments')
        .where('post_id', isEqualTo: post_id)
        .orderBy('upload_time', descending: true)
        .get();
    for (final element in postSnapshot.docs) {
      final comment = element.data();
      CommentsObj commentsObj = CommentsObj.fromMap(comment);
      UserObj userObj =
          UserObj.fromMap(await getUserData(commentsObj.author_id!));
      users.add(userObj);
      comments.add(commentsObj);
    }
    context
        .read<ViewPostBloc>()
        .add(LoadComments(commentsObj: comments, users: users));
    EasyLoading.dismiss();
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return userSnapshot.data()!;
  }

  Future<void> postComment(String post_id) async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    final msgAuthor = Global.storageServices.getUserProfile();
    CommentsObj commentsObj = CommentsObj(
      author_id: msgAuthor!.id,
      message: context.read<ViewPostBloc>().state.message,
      post_id: post_id,
      upload_time: Timestamp.now(),
    );
    final db = FirebaseFirestore.instance;
    await db.collection('Comments').add(commentsObj.toMap());
    EasyLoading.dismiss();
  }
}
