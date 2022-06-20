import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/AppUtil.dart';
import '../../../../utils/Constant.dart';
import '../../bloc/chat_bloc.dart';
import '../../bloc/chat_bloc_provider.dart';
import '../../model/chat_data.dart';
import '../../model/chat_message.dart';
import '../../service/observer.dart';
import '../../service/request_chats.dart';
import '../../service/signaling.dart';
import '../../widget/my_circle_avatar.dart';
import 'components/body.dart';

const pDefaultPadding = 20.0;

class MessagesScreen extends StatefulWidget {
  final ChatContact chat;

  const MessagesScreen({Key key, this.chat}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ChatBloc _chatBloc = ChatBloc();
  SignalingProvider _signaling;
  final ScrollController _scrollController = ScrollController();
  int index = 0;

  void _onChat(dynamic message) {
    if (widget.chat.id == message['from']) {
      _chatBloc.addMessageFrom(message);

      Timer(
          const Duration(milliseconds: 600),
          () => _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 80),
              ));
    }
  }

  void onPeerOnline(dynamic event) {
    setState(() {
      if (widget.chat.id == event) {
        widget.chat.online = true;
      }
    });
  }

  void onPeerOffline(dynamic event) {
    setState(() {
      if (widget.chat.id == event) {
        widget.chat.online = false;
      }
    });
  }

  void onReplyChat(dynamic mess) {
    _chatBloc.onReplyChat(mess);
  }

  @override
  void initState() {
    super.initState();
    _chatBloc.chat = widget.chat;
    _signaling = SignalingProvider();

    final observer = Observer(MSG_CHAT, _onChat);
    _signaling.registerObserver('Messages', observer);

    final observerOn = Observer(MSG_PEER_ON, onPeerOnline);
    _signaling.registerObserver('Chats_on', observerOn);

    final observerOff = Observer(MSG_PEER_OFF, onPeerOffline);
    _signaling.registerObserver('Chats_off', observerOff);

    final observerReply = Observer(REPLY_CHAT, onReplyChat);
    _signaling.registerObserver('reply_messages', observerReply);

    requestHistory();
    requestCheckOnline();
  }

  Future<void> requestCheckOnline() async {
    final RequestChats request = RequestChats();
    final bool result =
        await request.requestCheckOnline(context, widget.chat.id);

    if (result != null) {
      setState(() {
        widget.chat.online = result;
      });
    }
  }

  @override
  void dispose() {
    _signaling
      ..unregisterObserver('Messages')
      ..unregisterObserver('Chats_on')
      ..unregisterObserver('Chats_off')
      ..unregisterObserver('reply_messages');
    super.dispose();
  }

  List<ChatHistoryMessages> arrMess = [];
  Future<void> requestHistory() async {
    // await _signaling.requestGetHistory(context, widget.chat.id);

    final RequestChats request = RequestChats();
    final List<ChatHistory> result =
        await request.requestGetHistory(context, widget.chat.id);

    if (result != null) {
      for (int i = result.length - 1; i >= 0; i--) {
        for (int j = 0; j < result[i].messages.length; j++) {
          final ChatHistoryMessages item = result[i].messages[j];
          _chatBloc.addMessage(ChatMessage(
              text: item.body,
              time: item.time,
              sequence: result[i].sequence,
              messageStatus: MessageStatus.viewed.index,
              isSender: item.from == AppUtil.userId,
              to: result[i].id,
              index: j));
        }
      }

      Timer(
          const Duration(milliseconds: 1700),
          () => _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
              ));

      Timer(const Duration(milliseconds: 1500), () => _chatBloc.loadStore());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: buildAppBar(),
      body: ChatBlocProvider(
          bloc: _chatBloc,
          child: Body(arrMess: arrMess, scrollController: _scrollController)));

  AppBar buildAppBar() => AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Constants.colorMain,
        titleSpacing: 0,
        title: Row(
          children: [
            // BackButton(),
            Stack(
              children: [
                // CircleAvatar(
                //     radius: 20,
                //     backgroundImage: AssetImage('assets/images/avatar.jpg')),
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                      child: AppUtil.imageAvatarDoctor(
                          widget.chat.avatar, widget.chat.gender, 45, 45)),
                ),
                if (widget.chat.online != null && widget.chat.online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(
              width: pDefaultPadding * 0.7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.fullName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 1,
                ),
              ],
            ),
          ],
        ),
      );
}
