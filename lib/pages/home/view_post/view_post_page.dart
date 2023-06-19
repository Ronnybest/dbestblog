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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              foregroundImage:
                  NetworkImage(widget.postObj.auhtor_avatar!, scale: 0.5),
            ),
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 500,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: TransitionToImage(
                    image: AdvancedNetworkImage(
                      widget.postObj.image_link!,
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.postObj.description!,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
