import 'package:dbestblog/pages/new_post/bloc/new_post_bloc.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/new_post_states.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
    RegistrationWidgets _widgets = RegistrationWidgets(context: context);
    return Scaffold(
      appBar: _widgets.buildAppBar(titleText: 'New post'),
      body: BlocBuilder<NewPostBloc, NewPostStates>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.all(12),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      height: 500,
                      child: TextField(
                        expands: true,
                        maxLines: null,
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
