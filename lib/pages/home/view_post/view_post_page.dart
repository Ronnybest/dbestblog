import 'package:cached_network_image/cached_network_image.dart';
import 'package:dbestblog/common/models/comments.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_bloc.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_events.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_state.dart';
import 'package:dbestblog/pages/home/view_post/view_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../another_user_profile/bloc/another_user_profile_bloc.dart';
import '../../another_user_profile/bloc/another_user_profile_events.dart';

class ViewPostPage extends StatefulWidget {
  const ViewPostPage({super.key});

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  late ViewPostController _viewPostController;
  late PostObj _postObj;
  @override
  void initState() {
    super.initState();
    _viewPostController = ViewPostController(context: context);
    _postObj = context.read<ViewPostBloc>().state.currentPost!;
    _viewPostController.init(_postObj.post_id!);
  }

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ViewPostBloc>().add(const ResetComments());
        return true;
      },
      child: Scaffold(
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
            GestureDetector(
              onTap: () {
                context
                    .read<AnotherUserProfileBloc>()
                    .add(LoadProfileAndPosts(null, null, _postObj.author_id!));
                Navigator.of(context).pushNamed('/another_user_profile');
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                child: CircleAvatar(
                  radius: 18.r,
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  foregroundImage:
                      NetworkImage(_postObj.auhtor_avatar!, scale: 0.5),
                ),
              ),
            ),
          ],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200.w,
                child: Text(
                  _postObj.author_name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Nunito',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ViewPostBloc, ViewPostStates>(
          builder: (context, state) => SafeArea(
            child: Stack(children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.w),
                        child: CachedNetworkImage(
                          imageUrl: _postObj.image_link!,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                                  height: 250.h,
                                  child: LinearProgressIndicator(
                                      value: downloadProgress.progress)),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 16.h),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          _postObj.description!,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 36.h),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Comments',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.normal,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 10.h),
                    sliver: state.commentsObj != null &&
                            state.commentsObj!.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (context, index) => buildComment(
                                    state.commentsObj![index],
                                    state.users![index]),
                                childCount: state.commentsObj!.length),
                          )
                        : SliverToBoxAdapter(
                            child: Container(
                              child: Center(
                                child: Text(
                                  'No comments, be first!',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      width: 330.w,
                      child: Padding(
                        padding: EdgeInsets.all(10.0.w),
                        child: TextField(
                          controller: textEditingController,
                          onChanged: (value) => context
                              .read<ViewPostBloc>()
                              .add(WriteMsg(msg: value)),
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            hintText: 'Leave comment...',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: GestureDetector(
                        onTap: () async {
                          await _viewPostController
                              .postComment(_postObj.post_id!);
                          textEditingController.clear();
                          _viewPostController.init(_postObj.post_id!);
                        },
                        child: Container(child: Icon(Icons.send)),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
        //bottomNavigationBar: TextField(),
        //bottomSheet: TextField(),
      ),
    );
  }

  Widget buildComment(CommentsObj comment, UserObj user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context
                  .read<AnotherUserProfileBloc>()
                  .add(LoadProfileAndPosts(null, null, user.id!));
              Navigator.of(context).pushNamed('/another_user_profile');
            },
            child: CircleAvatar(
              radius: 18.r,
              foregroundImage: CachedNetworkImageProvider(user.avatarLink!),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: Text(
                          user.name!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp),
                        DateFormat('dd.MM.yy | HH:mm').format(
                          comment.upload_time!.toDate(),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 75.w,
                  child: Text(
                    comment.message!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.normal,
                        fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
