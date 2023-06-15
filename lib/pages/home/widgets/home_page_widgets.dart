import 'package:dbestblog/common/models/post.dart';
import 'package:flutter/material.dart';

Widget postGrid(PostObj item) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 120,
        ),
        Text(item.author_name!),
        Container(
          child: Image(
            image: NetworkImage(item.image_link!),
            fit: BoxFit.cover,
          ),
        ),
        Text(item.description!),
      ],
    ),
  );
}
