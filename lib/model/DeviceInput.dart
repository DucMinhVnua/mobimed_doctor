class DeviceInput {
  DeviceInput();

  String _id;
  String appId, platform, userId, uniqueId, tokenId;

  DeviceInput.fromJsonMap(Map<String, dynamic> map)
      : _id = map["_id"],
        appId = map["appId"],
        platform = map["platform"],
        userId = map["userId"],
        uniqueId = map["uniqueId"],
        tokenId = map["tokenId"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = _id;
    data['appId'] = appId;
    data['platform'] = platform;
    data['userId'] = userId;
    data['uniqueId'] = uniqueId;
    data['tokenId'] = tokenId;
    return data;
  }
}
