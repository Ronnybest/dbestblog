import 'package:dbestblog/common/models/post.dart';

abstract class HomeEvents {
  const HomeEvents();
}

class HomePost extends HomeEvents {
  const HomePost(this.posts);
  final List<PostObj> posts;
}
