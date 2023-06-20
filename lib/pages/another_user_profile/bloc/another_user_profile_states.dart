import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';

class AnotherUserProfileStates {
  final UserObj? userObj;
  final List<PostObj>? postObj;
  final String? userId;
  const AnotherUserProfileStates(
      {this.postObj = const <PostObj>[], this.userObj, this.userId});

  AnotherUserProfileStates copyWith(
      {UserObj? user, List<PostObj>? posts, String? userId}) {
    return AnotherUserProfileStates(
      userId: userId ?? this.userId,
      userObj: user ?? this.userObj,
      postObj: posts ?? this.postObj,
    );
  }

  AnotherUserProfileStates reset() {
    return const AnotherUserProfileStates(
      userObj: null,
      postObj: null,
    );
  }
}
