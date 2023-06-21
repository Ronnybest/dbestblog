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
                margin: EdgeInsets.only(right: 10),
                child: CircleAvatar(
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
              Text(
                _postObj.author_name!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: _postObj.image_link!,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                                  height: 250,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress)),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 16),
                    sliver: SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(_postObj.description!))),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 20),
                    sliver: state.users != null
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
                                child: Text('No comments'),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      width: 380,
                      child: TextField(
                        controller: textEditingController,
                        onChanged: (value) => context
                            .read<ViewPostBloc>()
                            .add(WriteMsg(msg: value)),
                        decoration: InputDecoration(
                          hintText: 'Leave comment...',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _viewPostController
                            .postComment(_postObj.post_id!);
                        textEditingController.clear();
                        _viewPostController.init(_postObj.post_id!);
                      },
                      child: Container(child: Icon(Icons.send)),
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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(user.avatarLink!)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(user.name!),
                SizedBox(
                  width: 10,
                ),
                Text(DateFormat('HH:mm').format(comment.upload_time!.toDate()))
              ],
            ),
            Text(comment.message!),
          ],
        ),
      ]),
    );
  }
}
