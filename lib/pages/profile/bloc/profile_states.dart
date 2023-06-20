import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';

class ProfileStates {
  final UserObj? userObj;
  final List<PostObj>? postObj;
  const ProfileStates({this.userObj, this.postObj});

  ProfileStates copyWith({UserObj? newObj}) {
    return ProfileStates(
      userObj: newObj ?? this.userObj,
      postObj: this.postObj,
    );
  }

  ProfileStates reset({UserObj? userObj}) {
    return const ProfileStates(
      userObj: null,
    );
  }

  ProfileStates getUserPost({List<PostObj>? posts}) {
    return ProfileStates(
      userObj: this.userObj,
      postObj: posts ?? this.postObj,
    );
  }
}
