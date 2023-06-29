import 'package:cloud_firestore/cloud_firestore.dart';

class MessageObj {
  late String? message_id;
  late String? message;
  late String? message_from_id;
  late String? chat_id;
  late Timestamp? upload_time;
  late bool? is_read;

  MessageObj({
    this.message_id,
    this.message,
    this.message_from_id,
    this.chat_id,
    this.upload_time,
    this.is_read,
  });

  MessageObj.fromMap(Map<String, dynamic> map) {
    message_id = map['message_id'];
    message = map['message'];
    message_from_id = map['message_from_id'];
    chat_id = map['chat_id'];
    upload_time = map['upload_time'] as Timestamp?;
    is_read = map['is_read'] as bool?;
  }

  Map<String, dynamic> toMap() {
    return {
      'message_id': message_id,
      'message': message,
      'message_from_id': message_from_id,
      'chat_id': chat_id,
      'upload_time': upload_time,
      'is_read': is_read,
    };
  }
}
