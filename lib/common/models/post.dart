import 'package:cloud_firestore/cloud_firestore.dart';

class PostObj {
  late String? post_id;
  late String? author_id;
  late String? author_name;
  late String? image_link;
  late String? description;
  late String? auhtor_avatar;
  late Timestamp? upload_time;

  PostObj({
    this.post_id,
    this.author_id,
    this.image_link,
    this.description,
    this.author_name,
    this.auhtor_avatar,
    this.upload_time,
  });

  PostObj.fromMap(Map<String, dynamic> map) {
    this.post_id = map['post_id'];
    this.author_id = map['author_id'];
    this.image_link = map['image_link'];
    this.description = map['description'];
    this.author_name = map['author_name'];
    this.auhtor_avatar = map['author_avatar'];
    this.upload_time = map['upload_time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': this.post_id,
      'author_id': this.author_id,
      'image_link': this.image_link,
      'description': this.description,
      'author_name': this.author_name,
      'author_avatar': this.auhtor_avatar,
      'upload_time': this.upload_time,
    };
  }
}
