import 'dart:ui';

import 'package:dbestblog/common/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';
import 'package:flutter_advanced_networkimage_2/zoomable.dart';

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
          Text('  '),
          Text(item.author_name!),
        ]),
        Container(
          height: 300,
          child: TransitionToImage(
            image: AdvancedNetworkImage(
              item.image_link!,
              timeoutDuration: const Duration(seconds: 30),
              retryLimit: 1,
            ),
            fit: BoxFit.cover,
            placeholder: Container(
              width: 300.0,
              height: 300.0,
              color: Colors.transparent,
              child: const Icon(Icons.refresh),
            ),
            imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            width: 300.0,
            height: 300.0,
            enableRefresh: true,
            loadingWidgetBuilder: (
              context,
              progress,
              imageData,
            ) {
              // print(imageData.lengthInBytes);
              return Container(
                width: 300.0,
                height: 300.0,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  value: progress == 0.0 ? null : progress,
                ),
              );
            },
          ),
        ),
        Text(item.description!),
      ],
    ),
  );
}
