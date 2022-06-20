class ArticleNewsData {
  String _id;
  String category;
  String createdTime;
  bool disable;
  String name;
  String shortDesc;
  String thumbUrl;
  String title;
  String updatedTime;
  String updater;
  String content;
  bool isRead;

  ArticleNewsData.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        category = map["category"],
        createdTime = map["createdTime"],
        disable = map["disable"],
        name = map["name"],
        shortDesc = map["shortDesc"],
        thumbUrl = map["thumbUrl"],
        title = map["title"],
        updatedTime = map["updatedTime"],
        isRead = map["is_read"],
        content = map.containsKey("content") ? map["content"] : "",
        updater = map["updater"];

  get id => _id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['category'] = category;
    data['createdTime'] = createdTime;
    data['disable'] = disable;
    data['name'] = name;
    data['shortDesc'] = shortDesc;
    data['thumbUrl'] = thumbUrl;
    data['title'] = title;
    data['content'] = content;
    data['updatedTime'] = updatedTime;
    data['updater'] = updater;
    data['is_read'] = isRead;
    return data;
  }
}
