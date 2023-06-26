import 'package:dbestblog/common/models/chats.dart';
import 'package:dbestblog/pages/chat/bloc/chats_bloc.dart';
import 'package:dbestblog/pages/chat/chats_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({super.key});

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  late ChatsController _chatsController;
  @override
  void initState() {
    super.initState();
    _chatsController = ChatsController(context: context);
    _chatsController.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsStates>(
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: state.chats?.length ?? 0,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => print(state.chats!.length),
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: buildChatItem(
                      state.chats?[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget buildChatItem(ChatsObj? chat) {
    return chat != null
        ? Container(
            height: 200,
            color: Colors.red,
            child: Text(chat.from_user_id!),
          )
        : Container(
            color: Colors.blue,
          );
  }
}
