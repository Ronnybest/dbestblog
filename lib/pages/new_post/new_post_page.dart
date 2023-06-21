import 'package:dbestblog/pages/new_post/bloc/new_post_bloc.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_events.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_states.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'new_post_controller.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key});

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
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            context.read<NewPostBloc>().add(Reset());
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(15.w),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      height: 340.h,
                      child: Container(
                        margin: EdgeInsets.all(10.w),
                        child: TextField(
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.sp),
                          onChanged: (value) => context
                              .read<NewPostBloc>()
                              .add(DescriptionNewPost(value)),
                          expands: true,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Input your post`s text here..',
                            hintStyle: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: state.image != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200.h,
                              width: 200.w,
                              child: Image(
                                fit: BoxFit.contain,
                                image: FileImage(
                                  state.image!,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context
                                  .read<NewPostBloc>()
                                  .add(EmptyImage(state.description!)),
                              child: Container(
                                child: Icon(Icons.delete),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => _newpostcontr.uploadPost(),
                style: FilledButton.styleFrom(
                  minimumSize: Size(300.w, 55.h),
                  elevation: 0,
                ),
                child: Text(
                  'Upload',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            FloatingActionButton(
              onPressed: () {
                _newpostcontr.selectImage();
              },
              child: const Icon(Icons.photo),
            ),
          ],
        ),
      ),
    );
  }
}
