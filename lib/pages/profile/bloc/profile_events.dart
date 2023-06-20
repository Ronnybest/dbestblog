import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';

abstract class ProfileEvents {
  const ProfileEvents();
}

class UpdateProfile extends ProfileEvents {
  const UpdateProfile(this.userObj);
  final UserObj userObj;
}

class ResetProfile extends ProfileEvents {
  const ResetProfile();
}

class GetUsersPosts extends ProfileEvents {
  const GetUsersPosts(this.posts);
  final List<PostObj> posts;
}
