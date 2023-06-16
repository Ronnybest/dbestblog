import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/pages/home/bloc/home_bloc.dart';
import 'package:dbestblog/pages/home/bloc/home_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController {
  final BuildContext context;
  HomeController({required this.context});
  final Map<String, dynamic> authorInfo = {
    'avatar': null,
    'name': null,
  };
  Future<void> init() async {
    print('Home controller init');
    List<PostObj> posts = [];
    final postSnapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('upload_time', descending: true)
        .get();
    for (final postDoc in postSnapshot.docs) {
      final post = postDoc.data();
      final authorId = post['author_id'];
      await getAuthorName(authorId);

      PostObj postObj = PostObj(); // Создаем новый экземпляр на каждой итерации

      post['author_name'] = authorInfo['name'];
      postObj.auhtor_avatar = authorInfo['avatar'];
      postObj.author_id = post['author_id'];
      postObj.image_link = post['image_link'];
      postObj.description = post['description'];
      postObj.author_name = post['author_name'];
      print(postObj.author_name);
      posts.add(postObj);
    }

    context.read<HomeBloc>().add(HomePost(posts));
  }

  Future<Map<String, dynamic>> getAuthorName(String authorId) async {
    final authorDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(authorId)
        .get();
    final authorData = authorDoc.data();
    authorInfo['avatar'] = authorData!['avatarLink'];
    authorInfo['name'] = authorData['name'];
    return authorInfo;
  }
}
