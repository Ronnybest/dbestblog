import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsObj {
  late String? chat_id;
  late String? from_user_id;
  late String? last_msg;
  late Timestamp? last_msg_time;
  late String? last_msg_user_id;
  late String? to_user_id;

  ChatsObj({
    this.chat_id,
    this.from_user_id,
    this.last_msg,
    this.last_msg_time,
    this.last_msg_user_id,
    this.to_user_id,
  });

  ChatsObj.fromMap(Map<String, dynamic> map) {
    this.chat_id = map['chat_id'];
    this.from_user_id = map['from_user_id'];
    this.last_msg = map['last_msg'];
    this.last_msg_time = map['last_msg_time'];
    this.last_msg_user_id = map['last_msg_user_id'];
    this.to_user_id = map['to_user_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'chat_id': this.chat_id,
      'from_user_id': this.from_user_id,
      'last_msg': this.last_msg,
      'last_msg_time': this.last_msg_time,
      'last_msg_user_id': this.last_msg_user_id,
      'to_user_id': this.to_user_id,
    };
  }
}
