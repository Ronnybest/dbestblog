import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsObj {
  late String? author_id;
  late String? post_id;
  late String? message;
  late Timestamp? upload_time;

  CommentsObj({
    this.author_id,
    this.post_id,
    this.message,
    this.upload_time,
  });

  CommentsObj.fromMap(Map<String, dynamic> map) {
    this.author_id = map['author_id'];
    this.post_id = map['post_id'];
    this.message = map['message'];
    this.upload_time = map['upload_time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'author_id': this.author_id,
      'post_id': this.post_id,
      'message': this.message,
      'upload_time': this.upload_time,
    };
  }
}
