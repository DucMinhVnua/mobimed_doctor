import 'dart:convert';

import 'package:flutter/material.dart';

enum MessageStatus { not_sent, sent, viewed }

class ChatMessage {
  String text, to;
  int messageStatus; // 0: not send, 1: send, 2: view
  bool isSender;
  DateTime time;
  int index, sequence;

  ChatMessage({
    @required this.text,
    @required this.messageStatus,
    @required this.isSender,
    @required this.time,
    @required this.index,
    @required this.sequence,
    @required this.to,
  });

  ChatMessage.fromJsonMap(Map<String, dynamic> map)
      : text = map['text'],
        to = map['to'],
        messageStatus = map['messageStatus'],
        isSender = map['isSender'],
        index = map['index'],
        sequence = map['sequence'],
        time =
            map['time'] != null ? DateTime.parse(map['time'].toString()) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['to'] = to;
    data['messageStatus'] = messageStatus;
    data['isSender'] = isSender;
    data['index'] = index;
    data['sequence'] = sequence;
    data['time'] = time != null ? time.toIso8601String() : time;

    return data;
  }

  static String encode(List<ChatMessage> chats) => json.encode(
        chats.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
      );

  static List<ChatMessage> decode(String chats) =>
      (json.decode(chats) as List<dynamic>)
          .map<ChatMessage>((item) => ChatMessage.fromJsonMap(item))
          .toList();
}
