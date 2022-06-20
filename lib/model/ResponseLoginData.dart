class ResponseLoginData {
  String accessToken;
  String tokenType;
  String scope;

  ResponseLoginData.fromJson(Map<String, dynamic> map)
      : accessToken = map["access_token"],
        tokenType = map["token_type"],
        scope = map["scope"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['scope'] = scope;
    return data;
  }
}
