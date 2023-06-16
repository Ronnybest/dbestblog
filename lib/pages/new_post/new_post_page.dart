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
    );
  }
}
