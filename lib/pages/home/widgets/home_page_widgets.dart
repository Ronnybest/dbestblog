import 'package:dbestblog/common/models/post.dart';
import 'package:flutter/material.dart';

Widget postGrid(PostObj item) {
  return Container(
    //padding: EdgeInsets.only(top: 10),
    //margin: EdgeInsets.only(top: 10),
    child: Column(
      //mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(children: [
          CircleAvatar(
            minRadius: 20,
            maxRadius: 20,
            foregroundImage: NetworkImage(item.auhtor_avatar!),
            backgroundColor: Colors.transparent,
          ),
          Text(item.author_name!),
        ]),
        Container(
          height: 300,
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
