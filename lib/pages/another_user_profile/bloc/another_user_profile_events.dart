import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';

abstract class AnotherUserProfileEvents {
  const AnotherUserProfileEvents();
}

class LoadProfileAndPosts extends AnotherUserProfileEvents {
  const LoadProfileAndPosts(this.user, this.posts, this.userId);
  final UserObj? user;
  final List<PostObj>? posts;
  final String userId;
}

class ResetAnotherProfile extends AnotherUserProfileEvents {
  const ResetAnotherProfile();
}
