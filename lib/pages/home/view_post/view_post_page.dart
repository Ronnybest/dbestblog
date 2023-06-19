import 'dart:ui';

import 'package:dbestblog/common/models/post.dart';
import 'package:flutter/material.dart';

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
      appBar:AppBar(
  // systemOverlayStyle: SystemUiOverlayStyle.light,
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(1),
    child: Container(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      //* height defines the thickness of the line
      height: .3,
    ),
  ),
  centerTitle: true,
  title: Row(
    children: [
      Text(
        widget.postObj.author_name!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'ABeeZee',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image(
    image: NetworkImage(widget.postObj.image_link!),
  ),
),
Padding(
  padding: const EdgeInsets.all(10.0),
  child:   Text(
    widget.postObj.description!,
  ),
)
            ],
          ),
        ),
      )
      ),
    );
  }
}
