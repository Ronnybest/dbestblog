import 'dart:ui';

import 'package:dbestblog/common/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';

class ViewPostPage extends StatefulWidget {
  const ViewPostPage({super.key, required this.postObj});
  final PostObj postObj;
  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //systemOverlayStyle: SystemUiOverlayStyle.light,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              //* height defines the thickness of the line
              height: .3,
            )),
        //backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              minRadius: 20,
              foregroundImage: NetworkImage(widget.postObj.auhtor_avatar!),
            ),
            Text(
              widget.postObj.author_name!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'ABeeZee',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Image(
                image: NetworkImage(widget.postObj.image_link!),
              ),
              Text(widget.postObj.description!),
              TextField(),
            ],
          ),
        ),
      )),
    );
  }
}
