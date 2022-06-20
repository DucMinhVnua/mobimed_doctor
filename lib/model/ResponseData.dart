
class ResponseData{
  String message;
  int code;
//  int page;
//  int pages;
  dynamic data;

  ResponseData(this.code, this.message, this.data);

  ResponseData.fromJson(Map<String, dynamic> map):
        message = map["message"],
        code = map["code"],
        data = map["data"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['code'] = code;
    data['data'] = data;
    return data;
  }
}