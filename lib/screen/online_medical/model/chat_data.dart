class ChatContact {
  String fullName, id, lastMessage, channel, phoneNumber, gender, avatar;
  int count;
  DateTime lastTime;
  bool online;

  ChatContact();

  ChatContact.fromJsonMap(Map<String, dynamic> map)
      : fullName = map['fullName'],
        id = map['id'],
        online = map['online'],
        phoneNumber = map['phoneNumber'],
        gender = map['gender'],
        lastMessage = map['lastMessage'],
        channel = map['channel'],
        count = map['count'],
        avatar = map['avatar'],
        lastTime = DateTime.parse(map['lastTime'].toString());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['id'] = id;
    data['online'] = online;
    data['lastMessage'] = lastMessage;
    data['channel'] = channel;
    data['count'] = count;
    data['lastTime'] = lastTime.toIso8601String();

    return data;
  }
}

class ChatHistory {
  String id, channel;
  int sequence;
  List<ChatHistoryMessages> messages;

  ChatHistory();

  ChatHistory.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        channel = map['channel'],
        sequence = map['sequence'],
        messages = map.containsKey('messages') && map['messages'] != null
            ? List<ChatHistoryMessages>.from(map['messages']
                .map((item) => ChatHistoryMessages.fromJsonMap(item)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel'] = channel;
    data['sequence'] = sequence;
    data['messages'] = messages.map((e) => e.toJson()).toList();

    return data;
  }
}

class ChatHistoryMessages {
  String body, from;
  DateTime time;
  bool seen;

  ChatHistoryMessages();
  ChatHistoryMessages.fromJsonMap(Map<String, dynamic> map)
      : body = map['body'],
        seen = map['seen'],
        from = map['from'],
        time = DateTime.parse(map['time'].toString());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    data['from'] = from;
    data['seen'] = seen;
    data['time'] = time.toIso8601String();

    return data;
  }
}
