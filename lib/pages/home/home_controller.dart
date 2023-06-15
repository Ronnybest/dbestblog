import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/pages/home/bloc/home_bloc.dart';
import 'package:dbestblog/pages/home/bloc/home_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController {
  final BuildContext context;
  HomeController({required this.context});

  Future<void> init() async {
    print('Home controller init');
    PostObj postObj = PostObj();
    List<PostObj> posts = [];
    final postSnapshot =
        await FirebaseFirestore.instance.collection('Posts').get();
    for (final postDoc in postSnapshot.docs) {
      final post = postDoc.data();
      final authorId = post['author_id'];
      final authorName = await getAuthorName(authorId);
      post['author_name'] = authorName;
      postObj.author_id = post['author_id'];
      postObj.image_link = post['image_link'];
      postObj.description = post['description'];
      postObj.author_name = post['author_name'];
      print(postObj.author_name);
      posts.add(postObj);
    }
    context.read<HomeBloc>().add(HomePost(posts));
  }

  Future<String> getAuthorName(String authorId) async {
    final authorDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(authorId)
        .get();
    final authorData = authorDoc.data();
    return authorData!['name'] ?? '';
  }
}
