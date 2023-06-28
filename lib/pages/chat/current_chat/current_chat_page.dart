import 'dart:async';

import 'package:dbestblog/common/models/message.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/chat/current_chat/bloc/current_chat_bloc.dart';
import 'package:dbestblog/pages/chat/current_chat/current_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../another_user_profile/bloc/another_user_profile_bloc.dart';
import '../../another_user_profile/bloc/another_user_profile_events.dart';

class ChattingPage extends StatefulWidget with WidgetsBindingObserver {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with WidgetsBindingObserver {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  StreamController<List<MessageObj>> _messagesController =
      StreamController<List<MessageObj>>.broadcast();

  Stream<List<MessageObj>> get chatsStream => _messagesController.stream;
  late CurrentChatController _chatController;

  UserObj myProfile = Global.storageServices.getUserProfile()!;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        // Клавиатура закрыта
      } else {
        // Клавиатура открыта
        Timer(Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _chatController = CurrentChatController(context: context);
    _chatController.fetchChats(_messagesController, scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<CurrentChatBloc>().add(const ClearMsg());
        return true;
      },
      child: BlocBuilder<CurrentChatBloc, CurrentChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              // systemOverlayStyle: SystemUiOverlayStyle.light,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  //* height defines the thickness of the line
                  height: .3,
                ),
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    context.read<AnotherUserProfileBloc>().add(
                        LoadProfileAndPosts(
                            null, null, state.another_user!.id!));
                    Navigator.of(context).pushNamed('/another_user_profile');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: CircleAvatar(
                      radius: 18.r,
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      foregroundImage: NetworkImage(
                          state.another_user!.avatarLink!,
                          scale: 0.5),
                    ),
                  ),
                ),
              ],
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.another_user!.name!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'Nunito',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<MessageObj>>(
                    stream: chatsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MessageObj> messages = snapshot.requireData;
                        return ListView(
                            controller: scrollController,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: messages.length,
                                itemBuilder: (context, index) =>
                                    buildMessage(messages[index]),
                              ),
                            ]);
                      } else {
                        return const Text('error');
                      }
                    },
                  ),
                ),
                buildInputText(),
              ],
            ),
          );
        },
      ),
    );
  }

Widget buildMessage(MessageObj msg) {
  final bool isLeftAligned = myProfile.id != msg.message_from_id;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
        //width: MediaQuery.of(context).size.width / 1.4 - 50.w,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300.0, minWidth: 50), // Установите максимальную ширину в 100.0 пикселей
                  child: Text(
                    msg.message!,
                    overflow: TextOverflow.fade,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      
    ),
  );
}


  Widget buildInputText() {
    return Row(children: [
      Expanded(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.w)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) =>
                        context.read<CurrentChatBloc>().add(WriteMessage(value)),
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      MaterialButton(
        minWidth: 0,
        padding: EdgeInsets.all(10.w),
        shape: const CircleBorder(),
        onPressed: context.read<CurrentChatBloc>().state.message != null &&
                context.read<CurrentChatBloc>().state.message != ''
            ? () {
                _chatController.sendMsg();
                _textEditingController.clear();
                context.read<CurrentChatBloc>().add(const ClearMsg());
              }
            : null,
        color: Theme.of(context).colorScheme.onSecondary,
        child: Icon(
          Icons.send,
          size: 20.w,
        ),
      )
    ]);
  }
}
