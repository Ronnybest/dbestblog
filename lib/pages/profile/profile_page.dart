import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/pages/profile/bloc/profile_bloc.dart';
import 'package:dbestblog/pages/profile/bloc/profile_states.dart';
import 'package:dbestblog/pages/profile/profie_controller.dart';
import 'package:dbestblog/pages/profile/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home/view_post/bloc/view_post_bloc.dart';
import '../home/view_post/bloc/view_post_events.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserObj userObj;
  late ProfileController _profileController;
  @override
  void initState() {
    super.initState();
    _profileController = ProfileController(context: context);
    userObj = _profileController.init();
    _profileController.getUserPosts(userObj.id!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileStates>(
      builder: (context, state) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'Edit profile',
                    child: Text(
                      'Edit profile',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Logout',
                    child: Text(
                      'Log out',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp),
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'Logout':
                      removeUserData(context);
                      break;
                    case 'Edit profile':
                      Navigator.of(context).pushNamed('/edit_profile');
                      break;
                  }
                },
              )
            ],
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
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            margin: EdgeInsets.all(16.w),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: buildAvatar(context, userObj.avatarLink!),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 10.h),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: buildText(
                        userObj.name!,
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
                        userObj.email!,
                        'Nunito',
                        12.sp,
                        FontWeight.normal,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 18.h),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: buildText(
                          userObj.bio!,
                          'Nunito',
                          14.sp,
                          FontWeight.normal,
                        ),
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
                                  LoadComments(postObj: state.postObj?[index]));
                              Navigator.of(context).pushNamed('/view_post');
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
          ),
        ),
      ),
    );
  }
}
