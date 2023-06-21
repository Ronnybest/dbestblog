import 'package:dbestblog/common/models/comments.dart';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/models/user.dart';

abstract class ViewPostEvents {
  const ViewPostEvents();
}

class LoadComments extends ViewPostEvents {
  const LoadComments({this.postObj, this.commentsObj, this.users});
  final PostObj? postObj;
  final List<CommentsObj>? commentsObj;
  final List<UserObj>? users;
}

class WriteMsg extends ViewPostEvents {
  const WriteMsg({this.msg});
  final String? msg;
}

class ResetComments extends ViewPostEvents {
  const ResetComments();
}
