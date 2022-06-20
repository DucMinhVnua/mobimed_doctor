import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../online_medical/model/chat_data.dart';
import '../online_medical/screen/chats/components/chat_card.dart';
import '../online_medical/screen/messages/message_screen.dart';
import '../online_medical/service/observer.dart';
import '../online_medical/service/request_chats.dart';
import '../online_medical/service/signaling.dart';

class TabChat extends StatefulWidget {
  const TabChat({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _TabChatState createState() => _TabChatState();
}

class _TabChatState extends State<TabChat> {
  SignalingProvider _signaling;
  var _peers = [];
  List<ChatContact> contacts = [];
  _TabChatState();

  TextEditingController edittingController = TextEditingController();
  String keySearch = '';
  Timer searchOnStoppedTyping;

  void _onPeersUpdate(event) {
    setState(() {
      _peers = event['peers'];

      // for (final element in chatsData) {
      //   element.isActive = false;
      // }

      // for (final peer in _peers) {
      //   final chat = chatsData.where((e) => e.id == peer['id']);
      //   if (chat.isNotEmpty) {
      //     chat.first.isActive = true;
      //   }
      // }
    });
  }

  Future<void> requestContact() async {
    final RequestChats request = RequestChats();
    final List<ChatContact> result = await request.requestGetContact(context);

    if (result != null) {
      setState(() {
        contacts = result;
      });
    }
  }

  void onPeerOnline(event) {
    setState(() {
      for (final ChatContact chat in contacts) {
        if (chat.id == event) {
          chat.online = true;
          break;
        }
      }
    });
  }

  void onPeerOffline(event) {
    setState(() {
      for (final ChatContact chat in contacts) {
        if (chat.id == event) {
          chat.online = false;
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _signaling = SignalingProvider();

    final observerOn = Observer(MSG_PEER_ON, onPeerOnline);
    _signaling.registerObserver('Chats_tab_chat_on', observerOn);
    final observerOff = Observer(MSG_PEER_OFF, onPeerOffline);
    _signaling.registerObserver('Chats_tab_chat_off', observerOff);
    final observer = Observer(MSG_CHAT, onChat);
    _signaling.registerObserver('Messages_tab_chat', observer);

    AppUtil.isReadMessage = false;
    requestContact();
  }

  void onChat(message) {
    setState(() {
      AppUtil.isReadMessage = false;
      final chat = contacts.where((e) => e.id == message['from']);
      if (chat.isNotEmpty) {
        chat.first
          ..lastMessage = message['body']
          ..lastTime = DateTime.now();
        // chat.first.lastTime = DateTime.now();
      }
    });
  }

  void onchangeHandler(String value) {
    setState(() {
      keySearch = value;
    });

    const duration = Duration(milliseconds: 1000);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = Timer(duration, () => search()));
  }

  Future<void> search() async {
    if (keySearch.isNotEmpty) {
      await getMoreData();
    } else {
      await requestContact();
    }
  }

  Future<void> getMoreData() async {
    final RequestChats request = RequestChats();
    final List<ChatContact> result =
        await request.requestGetContactSearch(context, keySearch);

    if (result != null) {
      setState(() {
        contacts = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Column(
        children: [
          AppUtil.searchWidget('Tìm kiếm tên, số điện thoại bệnh nhân',
              onchangeHandler, edittingController),
          Expanded(
            child: contacts.isNotEmpty
                ? ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) => ChatCard(
                      chat: contacts[index],
                      press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MessagesScreen(chat: contacts[index]),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ));
}
