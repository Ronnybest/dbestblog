import '../../../common/models/post.dart';

class HomeStates {
  const HomeStates({this.posts = const <PostObj>[]});
  final List<PostObj> posts;

  HomeStates copyWith({List<PostObj>? postObj}) {
    return HomeStates(posts: postObj ?? this.posts);
  }
}
