import 'dart:async';

import '../../../utils/AppUtil.dart';
import '../../../utils/Constant.dart';
import '../model/chat_data.dart';
import '../model/chat_message.dart';
import '../service/signaling.dart';

class ChatBloc {
  ChatContact chat;
  bool isSending = false;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> _messagesQueue = [];

  final _controller = StreamController<List<ChatMessage>>();

  Stream get stream => _controller.stream;

  void checkSendReconect() {
    AppUtil.showLogFull('Mess send: $isSending - ' + _messagesQueue[0].text);
    if (isSending) {
      return;
    }
    if (_messagesQueue.isNotEmpty) {
      isSending = true;
      SignalingProvider().sendMessage(_messagesQueue[0].text, chat.id);
    }
  }

  void addMessageFrom(dynamic message) {
    final ChatMessage mess = ChatMessage(
        text: message['body'],
        index: message['index'],
        to: message['from'],
        sequence: message['sequence'],
        messageStatus: MessageStatus.viewed.index,
        time: DateTime.parse(message['time']),
        isSender: false);

    // mess nhận đc khi mà đang gửi queue mess chưa gửi đc chưa làm
    _messages.add(mess);
    _controller.sink.add(_messages);
  }

  void addMessage(ChatMessage message) {
    _messages.add(message);
    _controller.sink.add(_messages);
  }

  void addMessageSend(String text) {
    int index = _messages.last.index + 1;
    int sequence = _messages.last.sequence;

    if (index >= 50) {
      index = 0;
      sequence += 1;
    }

    final ChatMessage message = ChatMessage(
        text: text,
        messageStatus: MessageStatus.not_sent.index,
        isSender: true,
        time: null,
        index: index,
        to: chat.id,
        sequence: sequence);

    _messagesQueue.add(message);
    saveStore();
    addMessage(message);
    checkSendReconect();
  }

  void onReplyChat(dynamic message) {
    AppUtil.showLogFull('Mess send: reply $message');
    isSending = false;

    final ChatMessage mess = _messagesQueue[0];
    if (mess != null) {
      _messagesQueue.remove(mess);
      saveStore();
    }

    _messages.firstWhere(
        (e) => e.index == message['index'] && e.sequence == message['sequence'])
      ..time = DateTime.parse(message['time'])
      ..messageStatus = MessageStatus.sent.index;

    _controller.sink.add(_messages);

    checkSendReconect();
  }

  void saveStore() {
    AppUtil.saveToSettting(
        'chat_${AppUtil.userId}_${Constants.nameApp}${chat.id}',
        ChatMessage.encode(_messagesQueue));
  }

  Future<void> loadStore() async {
    final String strQueue = await AppUtil.getFromSetting(
        'chat_${AppUtil.userId}_${Constants.nameApp}${chat.id}');
    AppUtil.showLogFull('Mess send: queue $strQueue');
    if (strQueue == null || strQueue.isEmpty) {
      return;
    }

    _messagesQueue = ChatMessage.decode(strQueue);

    for (final ChatMessage item in _messagesQueue) {
      _messages.add(item);
    }
    _controller.sink.add(_messages);
    checkSendReconect();
  }

  void fetchAllMessage() {
    _controller.sink.add(_messages);
  }

  void dispose() {
    _controller.close();
  }
}
