import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestblog/common/models/message.dart';
import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/chat/current_chat/bloc/current_chat_bloc.dart';
import 'package:dbestblog/pages/chat/current_chat/current_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../another_user_profile/bloc/another_user_profile_bloc.dart';
import '../../another_user_profile/bloc/another_user_profile_events.dart';

class ChattingPage extends StatefulWidget with WidgetsBindingObserver {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with WidgetsBindingObserver {
  final TextEditingController _textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final StreamController<List<MessageObj>> _messagesController =
      StreamController<List<MessageObj>>.broadcast();

  Stream<List<MessageObj>> get chatsStream => _messagesController.stream;
  late CurrentChatController _chatController;
  //GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  UserObj myProfile = Global.storageServices.getUserProfile()!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        // Клавиатура закрыта
      } else {
        // Клавиатура открыта
        // Timer(Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
        //});
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    _textEditingController.dispose();
    _messagesController.close();
    print('msg controller has been disposed');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _chatController = CurrentChatController(context: context);
    _chatController.fetchChats(_messagesController, scrollController);
    //scrollController.addListener(scrollListener);
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
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      state.another_user!.name!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFamily: 'Nunito',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
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
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
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

  Timestamp? prevDate;
  bool checkDateDifference(Timestamp currentDate) {
    if (prevDate != null) {
      DateTime dateTime1 = prevDate!.toDate();
      DateTime dateTime2 = currentDate.toDate();

      bool sameDay = dateTime1.year == dateTime2.year &&
          dateTime1.month == dateTime2.month &&
          dateTime1.day == dateTime2.day;

      if (!sameDay) {
        return true;
      }
    }
    return false;
  }

  Widget buildMessage(MessageObj msg) {
    final bool isLeftAligned = myProfile.id != msg.message_from_id;
    bool differenceDate = checkDateDifference(msg.upload_time!);
    bool nullablePrevDate = prevDate == null;
    prevDate = msg.upload_time!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Visibility(
            visible: differenceDate || nullablePrevDate,
            child: Center(
              child: Text(
                DateFormat('EEE, d.M.y').format(msg.upload_time!.toDate()),
              ),
            ),
          ),
          Align(
            alignment:
                isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
            //width: MediaQuery.of(context).size.width / 1.4 - 50.w,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IntrinsicWidth(
                  stepHeight: 10.h,
                  //stepWidth: 50.w,
                  //constraints: BoxConstraints(maxWidth: 130.0.w, minWidth: 20.w),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      //minHeight: 20.h,
                      //minWidth: 70.w,
                      maxWidth: 200.0.w, // Максимальная ширина карточки
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            msg.message!,
                            overflow: TextOverflow.fade,
                            maxLines: null,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Text(
                                    style: TextStyle(fontSize: 9.sp),
                                    DateFormat('HH:mm').format(
                                      msg.upload_time!.toDate(),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !isLeftAligned,
                                  child: Icon(
                                    msg.is_read != true
                                        ? Icons.done
                                        : Icons.done_all,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                    onChanged: (value) => context
                        .read<CurrentChatBloc>()
                        .add(WriteMessage(value)),
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
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
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
