import 'package:dbestblog/common/models/comments.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';

class ViewPostStates {
  final String? message;
  final PostObj? currentPost;
  final List<UserObj>? users;
  final List<CommentsObj>? commentsObj;
  const ViewPostStates(
      {this.currentPost, this.users, this.commentsObj, this.message});

  ViewPostStates copyWith(
      {PostObj? currentPost,
      List<CommentsObj>? commentsObj,
      List<UserObj>? users,
      String? msg}) {
    return ViewPostStates(
      currentPost: currentPost ?? this.currentPost,
      commentsObj: commentsObj ?? this.commentsObj,
      users: users ?? this.users,
      message: msg ?? this.message,
    );
  }

  ViewPostStates reset() {
    return const ViewPostStates(
      commentsObj: null,
      users: null,
    );
  }
}
