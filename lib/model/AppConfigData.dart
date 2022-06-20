class AppConfigData {
  AppConfigData() {}

  String id;
  String appId;
  String version, versionReview;
  String description, link, platform, privatePolicyUrl, termsUrl;
  bool registerable, forceUpdate;

  AppConfigData.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        appId = map['appId'],
        version = map['version'],
        versionReview = map['versionReview'],
        description = map['description'],
        link = map['link'],
        platform = map['platform'],
        privatePolicyUrl = map['privatePolicyUrl'],
        termsUrl = map['termsUrl'],
        registerable = map['registerable'],
        forceUpdate = map['forceUpdate'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['appId'] = appId;
    data['version'] = version;
    data['versionReview'] = versionReview;
    data['description'] = description;
    data['link'] = link;
    data['platform'] = platform;
    data['privatePolicyUrl'] = privatePolicyUrl;
    data['termsUrl'] = privatePolicyUrl;
    data['registerable'] = registerable;
    data['forceUpdate'] = forceUpdate;
    return data;
  }
}
