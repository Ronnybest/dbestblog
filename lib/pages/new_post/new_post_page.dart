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
        builder: (context, state) => Stack(
          children: [
            SingleChildScrollView(
  child: Container(
    margin: EdgeInsets.all(12),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 350,
      child: TextField(
        onChanged: (value) => context
            .read<NewPostBloc>()
            .add(DescriptionNewPost(value)),
        expands: true,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    ),
  ),
),

            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(16),
                child: FloatingActionButton(
                  onPressed: () {
                    _newpostcontr.selectImage();
                  },
                  child: Icon(Icons.photo),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Container(
          margin: EdgeInsets.symmetric(vertical:0, horizontal: 30),
          child: FilledButton(
            onPressed: () => _newpostcontr.uploadPost(),
            style: FilledButton.styleFrom(
              minimumSize: Size(320, 55),
              elevation: 0,
            ),
            child: Text('Upload'),
          ),
        ),
      ),
    );
  }
}



