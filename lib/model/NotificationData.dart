class NotificationData {
  String _id;
  String name;
  String description;
  String content;
  DateTime createdTime;

  NotificationData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        name = map["name"],
        description = map["description"],
        content = map.containsKey("content") && map["content"] != null
            ? map["content"]
            : "",
        createdTime = DateTime.parse(map['createdTime'].toString());

  get id => _id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['name'] = name;
    data['description'] = description;
    data['createdTime'] = createdTime;
    return data;
  }
}

class NotificationDataTypeData {
  String type;
  String linked;

  NotificationDataTypeData.fromJsonMap(Map<String, dynamic> map)
      : type = map["Type"],
        linked = map["Linked"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = type;
    data['Linked'] = linked;
    return data;
  }
}
