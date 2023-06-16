import 'dart:io';

import 'package:dbestblog/pages/new_post/bloc/new_post_bloc.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_events.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_states.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_post_controller.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
    final _widgets = RegistrationWidgets(context: context);
    final _newpostcontr = NewPostController(context: context);
    return Scaffold(
      appBar: _widgets.buildAppBar(titleText: 'New post'),
      body: BlocBuilder<NewPostBloc, NewPostStates>(
        builder: (context, state) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 350,
                    child: TextField(
                      onChanged: (value) => context
                          .read<NewPostBloc>()
                          .add(DescriptionNewPost(value)),
                      expands: true,
                      maxLines: null,
                    ),
                  ),
                ),
              ),
              Container(
                child: state.image != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image(
                              image: FileImage(state.image!),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context
                                .read<NewPostBloc>()
                                .add(EmptyImage(state.description)),
                            child: Container(
                              child: Icon(Icons.delete),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              GestureDetector(
                onTap: () => _newpostcontr.uploadPost(),
                child: Container(
                  width: 340,
                  height: 30,
                  color: Colors.red,
                  child: Text('Upload'),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _newpostcontr.selectImage();
        },
        child: Icon(Icons.photo),
      ),
    );
  }
}
