import 'package:dbestblog/pages/another_user_profile/another_user_profile_controller.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_bloc.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_events.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/models/post.dart';
import '../home/view_post/bloc/view_post_bloc.dart';
import '../home/view_post/bloc/view_post_events.dart';
import '../profile/widgets/profile_widgets.dart';

class AnotherUserProfilePage extends StatefulWidget {
  const AnotherUserProfilePage({super.key});

  @override
  State<AnotherUserProfilePage> createState() => _AnotherUserProfilePageState();
}

class _AnotherUserProfilePageState extends State<AnotherUserProfilePage> {
  late final AnotherUserProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnotherUserProfileController(context: context);
    _controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnotherUserProfileBloc, AnotherUserProfileStates>(
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          context
              .read<AnotherUserProfileBloc>()
              .add(const ResetAnotherProfile());
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
            body: state.postObj != null && state.userObj != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    margin: EdgeInsets.all(16.w),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: buildAvatar(
                                context, state.userObj!.avatarLink!),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(top: 10.h),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: buildText(
                                state.userObj!.name!,
                                'Nunito',
                                20.sp,
                                FontWeight.bold,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(top: 2.h),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: buildText(
                                state.userObj!.email!,
                                'Nunito',
                                12.sp,
                                FontWeight.normal,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                                child: Container(
                              child: IconButton(
                                icon: Icon(Icons.mail),
                                onPressed: () async {
                                  await _controller.createNewChat();
                                  print('new chat has been created');
                                },
                              ),
                            )),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: buildText(
                                state.userObj!.bio!,
                                'Nunito',
                                14.sp,
                                FontWeight.normal,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(top: 16.h),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                childCount: state.postObj?.length ?? 0,
                                (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<ViewPostBloc>().add(
                                          LoadComments(
                                              postObj: state.postObj?[index]));
                                      Navigator.of(context)
                                          .pushNamed('/view_post');
                                    },
                                    child: buildPostCard(
                                        state.postObj?[index] ?? PostObj()),
                                  );
                                },
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
