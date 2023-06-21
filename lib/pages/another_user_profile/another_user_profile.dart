import 'package:dbestblog/pages/another_user_profile/another_user_profile_controller.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_bloc.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_events.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  // late AnotherUserProfileController _controller;

  @override
  void initState() {
    super.initState();
    AnotherUserProfileController(context: context).init();
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
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: state.postObj != null && state.userObj != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: buildAvatar(
                                  context, state.userObj!.avatarLink!),
                            ),
                          ),
                          const SliverPadding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: buildText(
                                state.userObj!.name!,
                                'Nunito',
                                20,
                                FontWeight.normal,
                              ),
                            ),
                          ),
                          const SliverPadding(
                            padding: EdgeInsets.only(top: 2),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: buildText(
                                state.userObj!.email!,
                                'Nunito',
                                12,
                                FontWeight.normal,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: buildText(
                                state.userObj!.bio!,
                                'Nunito',
                                14,
                                FontWeight.normal,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 16),
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
