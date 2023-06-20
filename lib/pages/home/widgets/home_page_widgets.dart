import 'dart:ui';

import 'package:dbestblog/common/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';

Widget postGrid({required PostObj item, required BuildContext context}) {
  return IntrinsicHeight(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0), // Добавление отступа 20px снизу
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                minRadius: 20,
                maxRadius: 20,
                foregroundImage: NetworkImage(item.auhtor_avatar!),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 8),
              Text(item.author_name!, style: TextStyle(
              fontSize: 16,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.normal,
            ), ),
            ],
          ),
          SizedBox(height: 10),
          if (item.image_link != '')
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: TransitionToImage(
                  image: AdvancedNetworkImage(
                    item.image_link!,
                    timeoutDuration: const Duration(seconds: 30),
                    retryLimit: 1,
                  ),
                  fit: BoxFit.cover,
                  placeholder: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                    child: const Icon(Icons.refresh),
                  ),
                  imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  width: double.infinity,
                  height: double.infinity,
                  enableRefresh: true,
                  loadingWidgetBuilder: (
                    context,
                    progress,
                    imageData,
                  ) {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        value: progress == 0.0 ? null : progress,
                      ),
                    );
                  },
                ),
              ),
            ),
          SizedBox(height: 10),
          Text(
            item.description!,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.normal,
            ),            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    ),
  );
}

