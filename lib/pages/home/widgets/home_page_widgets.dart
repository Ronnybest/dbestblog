import 'package:dbestblog/common/models/post.dart';
import 'package:flutter/material.dart';

Widget postGrid(PostObj item) {
  return Container(
    //padding: EdgeInsets.only(top: 10),
    //margin: EdgeInsets.only(top: 10),
    child: Column(
      //mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(item.author_name!),
        Container(
          //height: 00,
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
