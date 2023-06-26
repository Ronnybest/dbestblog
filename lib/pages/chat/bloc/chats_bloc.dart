import 'dart:async';
import 'package:dbestblog/common/models/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/user.dart';
import '../../../global.dart';
import 'chats_event.dart';
import 'chats_state.dart';

// ...

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final StreamController<List<ChatsObj>> _chatsController =
      StreamController<List<ChatsObj>>.broadcast();

  Stream<List<ChatsObj>> get chatsStream => _chatsController.stream;

  ChatsBloc() : super(ChatsInitialState());

  Stream<ChatsState> mapEventToState(ChatsEvent event) async* {
    if (event is LoadChatsEvent) {
      yield* _mapLoadChatsEventToState(event);
    }
  }

  Stream<ChatsState> _mapLoadChatsEventToState(LoadChatsEvent event) async* {
    try {
      UserObj currentUser = Global.storageServices.getUserProfile()!;
      final querySnapshot1 = await FirebaseFirestore.instance
          .collection('Chats')
          .where('to_user_id', isEqualTo: currentUser.id)
          .get();
      final querySnapshot2 = await FirebaseFirestore.instance
          .collection('Chats')
          .where('from_user_id', isEqualTo: currentUser.id)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents1 =
          querySnapshot1.docs;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents2 =
          querySnapshot2.docs;

      List<ChatsObj> allChats = [];
      for (final postDoc in documents1) {
        final chat = postDoc.data();
        ChatsObj chatsObj = ChatsObj.fromMap(chat);
        allChats.add(chatsObj);
      }
      for (final postDoc in documents2) {
        final chat = postDoc.data();
        ChatsObj chatsObj = ChatsObj.fromMap(chat);
        allChats.add(chatsObj);
      }

      _chatsController.sink.add(allChats);
      yield ChatsLoadedState(chats: allChats);
    } catch (error) {
      yield ChatsErrorState(error: error.toString());
    }
  }

  @override
  Future<void> close() {
    _chatsController.close();
    return super.close();
  }
}
